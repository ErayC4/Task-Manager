class DeleteRepeatScheduleInTasks < ActiveRecord::Migration[7.1]
  def change
    remove_column :repeat_schedule
  end
end
