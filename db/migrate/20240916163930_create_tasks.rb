class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :notes
      t.boolean :revised
      t.json :repeat_schedule

      t.timestamps
    end
  end
end
