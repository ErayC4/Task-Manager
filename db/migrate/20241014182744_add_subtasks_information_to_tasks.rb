class AddSubtasksInformationToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :subtask_title, :string
    add_column :tasks, :subtask_left_of_at, :string
    add_column :tasks, :subtask_finished, :boolean
  end
end
