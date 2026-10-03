class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      t.references :host, null: false, foreign_key: { to_table: :users }
      t.string :address, null: false
      t.string :neighborhood, null: false
      t.string :property_type, null: false
      t.integer :bedrooms, null: false
      t.integer :bathrooms, null: false
      t.text :shared_spaces
      t.string :amenities, array: true, default: [], null: false

      t.timestamps
    end

    add_index :properties, :neighborhood
    add_index :properties, :amenities, using: "gin"
  end
end