require_relative '../rails_helper'

describe MomentumCms, 'Module' do
  context 'module' do
    it 'should be a module' do
      expect(MomentumCms.is_a?(Module))
    end
  end
end