json.extract! task, :id, :title, :notes, :revised, :repeat_schedule, :created_at, :updated_at
json.url task_url(task, format: :json)
