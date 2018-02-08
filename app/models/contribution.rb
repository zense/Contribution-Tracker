class Contribution < ApplicationRecord
  belongs_to :user
  validates :contribution_type, presence: true, length: {maximum: 50}
  validates :name, presence: true, length: {maximum: 100}
  validates :description, length: {maximum: 200}
  validates :name, uniqueness: {scope: :user_id}
end
