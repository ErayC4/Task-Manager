class CreateSubtasks < ActiveRecord::Migration[7.1]
  def change
    create_table :subtasks do |t|
      t.string :title
      t.string :left_of_at
      t.boolean :finished
      t.json :make_later

      t.timestamps
    end
  end
end
