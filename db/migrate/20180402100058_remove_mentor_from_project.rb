class RemoveMentorFromProject < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :mentor_id, :integer
  end
end
