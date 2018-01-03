json.extract! contribution, :id, :type, :name, :description, :status, :belongs_to, :created_at, :updated_at
json.url contribution_url(contribution, format: :json)
