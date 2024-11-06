class AddSubtaskToNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :notes, :subtask, :string
  end
end
