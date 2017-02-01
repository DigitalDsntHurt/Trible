class CreateMashups < ActiveRecord::Migration[5.0]
  def change
    create_table :mashups do |t|
      t.string :mashup_text
      t.boolean :keep?
      t.timestamps
    end
  end
end
