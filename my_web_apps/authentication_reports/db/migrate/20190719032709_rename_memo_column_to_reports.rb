# frozen_string_literal: true

class RenameMemoColumnToReports < ActiveRecord::Migration[5.2]
  def change
    rename_column :reports, :memo, :content
  end
end
