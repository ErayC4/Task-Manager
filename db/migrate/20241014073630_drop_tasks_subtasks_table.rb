class DropTasksSubtasksTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :subtasks_tasks
  end
end
