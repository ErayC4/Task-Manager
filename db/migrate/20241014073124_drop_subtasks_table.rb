class DropSubtasksTable < ActiveRecord::Migration[7.1]
  def change
      drop_table :subtasks
  end
end
