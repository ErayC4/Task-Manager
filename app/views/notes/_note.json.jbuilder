json.extract! note, :id, :title, :content, :questions, :created_at, :updated_at
json.url note_url(note, format: :json)
