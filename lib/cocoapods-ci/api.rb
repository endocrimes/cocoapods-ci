module CocoapodsCi
  class API
    def initialize(url)
      @base_url = url
    end

    def fetch_spec(name, version)
      url = File.join(@base_url, 'specs', name, version.to_s, 'podspec.json')
      spec_response = Net::HTTP.get_response(URI(url))
      unless Net::HTTPSuccess === spec_response
        raise Informative, "Download failed: #{spec_response} #{spec_response.body}"
      end
      spec_response.body
    end
  end
end
