class CreatePokemon < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemon do |t|
      t.integer :pokedex_id, null: false
      t.string :name, null: false
      t.string :sprite, null: false
      t.timestamps null: false
    end
  end
end
