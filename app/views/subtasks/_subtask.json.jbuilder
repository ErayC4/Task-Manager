json.extract! subtask, :id, :title, :left_of_at, :finished, :make_later, :created_at, :updated_at
json.url subtask_url(subtask, format: :json)
