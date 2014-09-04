class CreateColours < ActiveRecord::Migration
  def change
    create_table :colours do |t|
      t.string  :name
      t.integer :red,   null: false, default: 0
      t.integer :green, null: false, default: 0
      t.integer :blue,  null: false, default: 0

      t.timestamps
    end
  end
end
