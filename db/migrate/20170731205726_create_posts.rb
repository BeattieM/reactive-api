class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :uuid, null: false
      t.belongs_to :user, index: true
      t.string :comment, limit: 140, null: false
      t.integer :pokemon_id, null: false
      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
