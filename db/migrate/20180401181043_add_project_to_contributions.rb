class AddProjectToContributions < ActiveRecord::Migration[5.1]
  def change
    change_table :contributions do |t|
      t.references :mentor, foreign_key: {to_table: :users}
      t.references :mentee, foreign_key: {to_table: :users}
    end
  end
end
