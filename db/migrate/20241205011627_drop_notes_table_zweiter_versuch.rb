class DropNotesTableZweiterVersuch < ActiveRecord::Migration[7.1]
  def change
    drop_table :notes
  end
end
