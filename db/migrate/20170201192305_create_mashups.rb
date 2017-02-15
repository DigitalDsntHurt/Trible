class CreateMashups < ActiveRecord::Migration[5.0]
  def change
    create_table :mashups do |t|
      t.string :mashup_text
      t.boolean :tweet?, :default => false
      t.boolean :tweeted?, :default => false
      t.timestamps
    end
  end
end
