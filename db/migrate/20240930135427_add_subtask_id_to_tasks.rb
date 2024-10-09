class AddSubtaskIdToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :subtask_id, :integer
    add_index  :tasks, :subtask_id
  end
end
