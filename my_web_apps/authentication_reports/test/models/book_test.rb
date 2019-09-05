# frozen_string_literal: true

require "test_helper"

class BookTest < ActiveSupport::TestCase
  def test_create_book
    book = Book.create(title: "bible", memo: "content")
    assert_equal "bible", book.title
    assert_equal "content", book.memo
  end
end
