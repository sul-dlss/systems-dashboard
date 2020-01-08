class CreateDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :details do |t|
      t.integer :server_id
      t.string :category
      t.string :name
      t.text :value

      t.timestamps null: false
    end
    add_index :details, [:server_id, :category, :name], unique: true
  end
end
