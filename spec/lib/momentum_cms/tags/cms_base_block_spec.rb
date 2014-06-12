require_relative '../../../rails_helper'

describe MomentumCms::Tags::CmsBaseBlock, 'Library' do
  context '.new' do
    it 'should create a basic cms base block' do
      expect {
        o = MomentumCms::Tags::CmsBaseBlock.new('tag', 'params', ['{% endtag %}'])
        expect(o.nil?).to_not be true
        expect(o.is_a?(Liquid::Block)).to be true
      }.to_not raise_error
    end
  end
end


