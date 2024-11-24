class AddContentToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :content, :json
  end
end
