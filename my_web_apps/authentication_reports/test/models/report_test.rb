# frozen_string_literal: true

require "test_helper"

class ReportTest < ActiveSupport::TestCase
  def test_create_report
    report = Report.create(content: "report is good")
    assert_equal "report is good", report.content
  end
end
