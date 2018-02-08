class AddStatsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :commits, :integer, default: 0
    add_column :users, :pull_requests, :integer, default: 0
    add_column :users, :issues, :integer, default: 0
    add_column :users, :total, :integer, default: 0
  end
end
