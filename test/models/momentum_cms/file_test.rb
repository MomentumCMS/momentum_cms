require_relative '../../test_helper'

class MomentumCms::FileTest < ActiveSupport::TestCase

  def setup
    @image_file = File.new('test/fixtures/files/image.png')
    @text_file  = File.new('test/fixtures/files/text.txt')
  end

  def test_file_types
    file = MomentumCms::File.new

    file.file = @image_file
    assert file.is_image?

    file.file = @text_file
    refute file.is_image?
  end
end
