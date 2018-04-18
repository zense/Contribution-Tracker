class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.boolean :role_type

      t.timestamps
    end
  end
end
