class CreateContributions < ActiveRecord::Migration[5.1]
  def change
    create_table :contributions do |t|
      t.string :contribution_type
      t.string :name
      t.string :description
      t.string :status
      t.belongs_to :user

      t.timestamps
    end
  end
end
