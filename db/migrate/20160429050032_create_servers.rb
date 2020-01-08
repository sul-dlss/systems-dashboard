class CreateServers < ActiveRecord::Migration[4.2]
  def change
    create_table :servers do |t|
      t.string :hostname
      t.timestamps null: false
    end
  end
end
