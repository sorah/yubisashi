class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :english
      t.string :japanese
      t.string :romaji
      t.string :comment
      t.integer :group_id

      t.timestamps
    end
  end
end
