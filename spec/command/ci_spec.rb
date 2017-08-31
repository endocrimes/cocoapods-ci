require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Ci do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ ci }).should.be.instance_of Command::Ci
      end
    end
  end
end

