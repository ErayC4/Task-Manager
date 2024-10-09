class CreateJoinTableSubtasksTasks < ActiveRecord::Migration[7.1]
  def change
    create_join_table :subtasks, :tasks do |t|
      t.index [:subtask_id, :task_id]
      t.index [:task_id, :subtask_id]
    end
  end
end
