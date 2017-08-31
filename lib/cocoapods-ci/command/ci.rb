module Pod
  class Command
    include ProjectDirectory

    # The CI command will setup a fake copy of a specs repo based on downloading
    # specifications from a web service rather than having the full clone of the
    # `master` repo and install them.
    #
    class Ci < Command
      self.summary = 'Install Pods without cloning the master specs repo.'

      def initialize(argv)
        super
      end

      def validate!
        super
        raise Informative, 'Must specify a COCOAPODS_CI_URL env var' unless service_url
      end

      def run
        verify_podfile_exists!
        create_spec_repo!
        install!
      end

      def create_spec_repo!
        Pod::UI.info 'Creating ephemeral specs repo'
        repo_path = Dir.mktempdir('cocoapods-ci')
        repo_path.join('Specs').mkpath
        fake_source = Pod::MasterSource.new(repo_path)

        download_and_store_specs(fake_source, config.lockfile)

        sources_manager = config.sources_manager
        def sources_manager.source_repos
          cleaned = super.select {|r| r.basename != 'master' }
          cleaned << repo_path
        end

        Pod::UI.info 'Setting up a fake git repo' do
          Pod::Executable.execute_command :git, %W(-C #{repo_path} init .)
          Pod::Executable.execute_command :git, %W[-C #{repo_path} remote add origin https://github.com/CocoaPods/Specs.git]
        end
      end

      def download_and_store_specs(source, lockfile)
        Pod::UI.info 'Downloading specs' do
          names_and_versions = lockfile.pod_names.map do |n|
            [Pod::Specification.root_name(n), lockfile.version(n)]
          end.uniq

          names_and_versions.each do |name, version|
            download_and_store_spec(source, name, version)
          end
        end
      end

      def download_and_store_spec(source, name, version)
        Pod::UI.info "Downloading spec for #{name} (#{version})" do
          spec_contents = api_client.fetch_spec(name, version)
          path = source.pod_path(name).join(version.to_s, "#{name}.podspec.json")
          path.parent.mkpath
          spec_path.open("w") {|f| f.write(spec_contents) }
        end
      end

      def install!
        installer = installer_for_config
        installer.repo_update = false
        installer.update = false
        installer.install!
      end

      def api_client
        @api_client ||= CocoapodsCi::API.new(service_url)
      end

      def service_url
        ENV['COCOAPODS_CI_URL']
      end
    end
  end
end
