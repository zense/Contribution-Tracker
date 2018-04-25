class ChangeRoleType < ActiveRecord::Migration[5.1]
  def change
    remove_column :roles, :role_type, :integer
    add_column :roles, :role_type, :string
  end
end
