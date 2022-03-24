class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :strIngredient, null: false
      t.string :strDescription, null: true
      t.string :strImageSource, null: true

      t.timestamps
    end
  end
end
