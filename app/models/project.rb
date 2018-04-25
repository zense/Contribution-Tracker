class Project < ApplicationRecord
  has_many :roles
  #has_many :mentors,-> {where 'role_type = "mentor"'}, class_name: "User",  through: :roles
  #has_many :mentees,-> {where 'role_type = "mentee"'}, class_name: "User",  through: :roles
  has_many :working_roles, -> {where(role_type: "mentee")}, class_name: "Role"
  has_many :mentoring_roles, -> {where(role_type: "mentor")}, class_name: "Role"
  has_many :mentees, through: :working_roles, source: :user
  has_many :mentors, through: :mentoring_roles, source: :user
  validates :title, presence: true, uniqueness: true
end
