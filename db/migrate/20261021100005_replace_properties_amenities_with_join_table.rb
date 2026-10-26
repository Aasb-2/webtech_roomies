class ReplacePropertiesAmenitiesWithJoinTable < ActiveRecord::Migration[8.1]
  def up
    remove_index :properties, :amenities, if_exists: true
    remove_column :properties, :amenities
  end

  def down
    add_column :properties, :amenities, :string, array: true, default: [], null: false
    add_index :properties, :amenities, using: "gin"
  end
end