class AddTaskIdToSubtasks < ActiveRecord::Migration[7.1]
  def change
    add_column :subtasks, :task_id, :integer
    add_index  :subtasks, :task_id
  end
end
