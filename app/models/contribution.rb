class Contribution < ApplicationRecord
    validates :contribution_type, presence: true, length: {maximum: 50}
    validates :name, presence: true, length: {maximum: 100}
    validates :description, length: {maximum: 200}
end
