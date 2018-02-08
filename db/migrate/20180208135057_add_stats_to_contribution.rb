class AddStatsToContribution < ActiveRecord::Migration[5.1]
  def change
    add_column :contributions, :commits, :integer, default: 0
    add_column :contributions, :pull_requests, :integer, default: 0
    add_column :contributions, :issues, :integer, default: 0
    add_column :contributions, :total, :integer, default: 0
  end
end
