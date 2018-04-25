class ChangeColumnInProject < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :status, :string
    add_column :projects, :status, :integer
  end
end
