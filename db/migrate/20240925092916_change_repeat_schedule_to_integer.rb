class ChangeRepeatScheduleToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :tasks, :repeat_schedule, :string
  end
end
