class CreateCocktails < ActiveRecord::Migration[7.0]
  def change
    create_table :cocktails do |t|
      t.string :name, null: false
      t.string :photo, null: false
      t.references :category, null: false, foreign_key: true
      t.string :desc, null: false

      t.timestamps
    end
  end
end
