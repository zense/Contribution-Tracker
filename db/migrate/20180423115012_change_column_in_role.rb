class ChangeColumnInRole < ActiveRecord::Migration[5.1]
  def change
    remove_column :roles, :role_type, :string
    add_column :roles, :role_type, :integer
  end
end
