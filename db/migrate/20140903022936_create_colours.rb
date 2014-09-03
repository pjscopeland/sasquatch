class CreateColours < ActiveRecord::Migration
  def change
    create_table :colours do |t|
      t.string  :name,  null: false
      t.integer :red,   null: false
      t.integer :green, null: false
      t.integer :blue,  null: false

      t.timestamps
    end
  end
end
