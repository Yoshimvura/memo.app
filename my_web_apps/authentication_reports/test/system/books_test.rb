# frozen_string_literal: true

require "application_system_test_case"

class BooksTest < ApplicationSystemTestCase
  include Warden::Test::Helpers

  setup do
    Warden.test_mode!
    @user = users(:john)
    login_as(@user, scope: :user)
    @book = books(:test_book)
  end


  test "visiting the index" do
    visit books_path
    assert_equal("bible", @book.title)
  end

  test "creating a Book" do
    visit new_book_path(@user)

    fill_in "作品名", with: "ブックタイトル"
    fill_in "Memo", with: "メモの内容"
    click_on "登録する"

    assert_text "ブック新規作成しました"
  end

  test "updating a Book" do
    visit new_book_path(@user)

    fill_in "作品名", with: "ブックタイトル"
    fill_in "Memo", with: "メモの内容"
    click_on "登録する"
    click_link "Back"
    click_link "Edit"

    fill_in "Memo", with: "メモエディット"
    fill_in "作品名", with: "タイトルエディット"
    click_on "更新する"

    assert_text "ブック更新しました"
  end

  test "destroying a Book" do
    visit new_book_path(@user)

    fill_in "作品名", with: "ブックタイトル"
    fill_in "Memo", with: "メモの内容"
    click_on "登録する"
    click_link "Back"

    page.accept_confirm do
      click_link "Destroy", match: :first
    end

    assert_text "ブック削除しました"
  end
end
