# frozen_string_literal: true

require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  def test_create_relationship
    relationship = Relationship.create(follower_id: 1)
    assert_equal 1, relationship.follower_id
  end
end
