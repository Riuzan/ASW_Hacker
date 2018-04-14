json.extract! contribution, :id, :title, :url, :text, :votes, :user_id, :created_at, :updated_at
json.url contribution_url(contribution, format: :json)
