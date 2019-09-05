 # frozen_string_literal: true

 require "application_system_test_case"

 class ReportsTest < ApplicationSystemTestCase
   include Warden::Test::Helpers

   setup do
     Warden.test_mode!
     @user = users(:john)
     login_as(@user, scope: :user)
     @report = reports(:content)
   end

   test "visiting the index" do
     visit reports_path
     assert_equal("レポート内容", @report.content)
   end

   test "creating a Report" do
     visit new_report_path(@user)

     fill_in "Content", with: "レポートタイトル"
     click_on "登録する"

     assert_text "レポート新規作成しました"
   end

   test "updating a Report" do
     visit reports_path
     click_link "Edit"

     fill_in "Content", with: "レポートエディット"
     click_on "更新する"

     assert_text "レポート更新しました"
   end

   test "destroying a Report" do
     visit new_report_path(@user)

     fill_in "Content", with: "レポートタイトル"
     click_on "登録する"
     click_link "Back"

     page.accept_confirm do
       click_on "Destroy", match: :first
     end

     assert_text "レポート削除しました"
   end
 end
