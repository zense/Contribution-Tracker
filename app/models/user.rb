class User < ApplicationRecord
  has_many :roles
  has_many :working_roles, -> {where 'role_type = "mentee"'}, class_name: "Role"
  has_many :mentoring_roles, -> {where 'role_type = "mentor"'}, class_name: "Role"
  has_many :working_projects, through: :working_roles, source: :project
  has_many :mentoring_projects, through: :mentoring_roles, source: :project

  has_many :contributions
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.admin = false
      user.oauth_token = auth.credentials.token
    end
  end
end
