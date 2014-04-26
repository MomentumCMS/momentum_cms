require 'test_helper'

class MomentumCms::LocaleTest < ActiveSupport::TestCase

  def test_fixture_validity
    MomentumCms::Locale.all.each do |locale|
      assert locale.valid?
    end
  end

end
