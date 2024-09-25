class DeleteRepeatSchedule < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :repeat_schedule, :json
  end
end
