class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.references :property, null: false, foreign_key: true
      t.decimal :monthly_rent, precision: 10, scale: 2, null: false
      t.decimal :deposit, precision: 10, scale: 2, null: false
      t.date :available_date, null: false
      t.integer :minimum_stay
      t.boolean :furnished, null: false, default: false
      t.boolean :private_bathroom, null: false, default: false
      t.text :description
      t.string :state, null: false, default: "draft"

      t.timestamps
    end

    add_index :listings, :state
    add_index :listings, :monthly_rent
    add_index :listings, :available_date
  end
end