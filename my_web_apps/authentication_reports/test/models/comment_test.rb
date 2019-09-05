# frozen_string_literal: true

require "test_helper"

class CommentTest < ActiveSupport::TestCase
  def test_create_comment
    comment = Comment.create(comment: "comment is good")
    assert_equal "comment is good", comment.comment
  end
end
