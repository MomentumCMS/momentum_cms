require 'test_helper'

class ApiKeyTest < ActiveSupport::TestCase

  def test_fixture_validity
    MomentumCms::ApiKey.all.each do |api_key|
      assert api_key.valid?
    end
  end

  def test_create
    assert_difference "MomentumCms::ApiKey.count" do
      api_key = MomentumCms::ApiKey.create(
        scope: 'session'
      )
      assert api_key.access_token.present?
    end
  end

  def test_sets_correct_expiry_date
    api_key = MomentumCms::ApiKey.create(
      scope: 'session'
    )
    assert_equal 4.hours.from_now.to_s, api_key.expired_at.to_s
    api_key = MomentumCms::ApiKey.create(
      scope: 'api'
    )
    assert_equal 30.days.from_now.to_s, api_key.expired_at.to_s
  end

end
