class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :title
      t.references :mentor, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
