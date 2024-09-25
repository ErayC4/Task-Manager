class AddStartingTimeToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :starting_time, :string
    add_column :tasks, :ending_time, :string
    add_column :tasks, :is_revision, :boolean
    add_column :tasks, :repeat_schedule, :integer
  end
end
