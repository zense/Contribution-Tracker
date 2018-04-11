class Role < ApplicationRecord
  belongs_to :user
  belongs_to :project
  validates_uniqueness_of :user_id, scope: [:project_id, :role_type]
end
