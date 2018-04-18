class AddTitleToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :description, :string
    add_column :projects, :status, :string
  end
end
