json.extract! resume, :id, :name, :static_data, :dynamic_data, :created_at, :updated_at
json.url resume_url(resume, format: :json)
