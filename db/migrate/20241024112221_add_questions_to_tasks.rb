class AddQuestionsToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :questions, :text
  end
end
