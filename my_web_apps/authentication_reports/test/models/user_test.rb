# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  def test_create_User
    user = User.create(email: "a@b")
    assert_equal "a@b", user.email
  end
end
