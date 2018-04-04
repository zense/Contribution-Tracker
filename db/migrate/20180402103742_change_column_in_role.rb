class ChangeColumnInRole < ActiveRecord::Migration[5.1]
  def change
    change_column :roles, :role_type, :string
  end
end
