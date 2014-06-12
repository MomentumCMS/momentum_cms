require_relative '../../rails_helper'

describe MomentumCms::File, 'Model' do
  before(:each) do
    @file = create(:file)
  end

  context 'model' do
    it 'should have a valid factory' do
      expect(@file.valid?).to be true
    end

    it 'should have unique identifier' do
      site = create(:site)
      expect { create(:file, identifier: 'foo', site: site) }.to change { MomentumCms::File.count }.by(1)
      site = build(:file, identifier: 'foo', site: site)
      site.save
      expect(site.errors.include?(:identifier)).to be true
    end
  end

  context '#is_image?' do
    it 'should respond to is_image if it is an image' do
      @image_file = File.new('spec/fixtures/files/image.png')
      @text_file = File.new('spec/fixtures/files/text.txt')
      file = create(:file)
      file.file = @image_file
      expect(file.is_image?).to be true
      file.file = @text_file
      expect(file.is_image?).to be false
    end
  end
end
