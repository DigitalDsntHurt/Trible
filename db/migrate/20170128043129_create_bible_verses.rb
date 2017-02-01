class CreateBibleVerses < ActiveRecord::Migration[5.0]
  def change
    create_table :bible_verses do |t|
      t.string :verse_num
      t.string :verse_text

      t.timestamps
    end
  end
end
