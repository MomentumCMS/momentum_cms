require_relative '../../rails_helper'

describe MomentumCms::Fixture::Importer, 'Library' do
  context '.new' do
    it 'should import all the defined site fixtures' do
      expect {
        expect {
          MomentumCms::Fixture::Importer.new(source: 'example-a', site: SecureRandom.hex).import!
        }.to change { MomentumCms::Page.count }.by(8)
      }.to change { MomentumCms::Site.count }.by(1)
    end
  end
end


