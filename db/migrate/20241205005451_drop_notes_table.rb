class DropNotesTable < ActiveRecord::Migration[7.0]
  def up
    drop_table :notes
  end

  def down
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.text :questions
      t.string :subtask
      t.string :color
      t.timestamps
    end
  end
end
