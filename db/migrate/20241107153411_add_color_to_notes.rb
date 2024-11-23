class AddColorToNotes < ActiveRecord::Migration[7.1]
  def change
    add_column :notes, :color, :string
  end
end
