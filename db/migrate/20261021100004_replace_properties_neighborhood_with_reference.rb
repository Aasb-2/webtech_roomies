class ReplacePropertiesNeighborhoodWithReference < ActiveRecord::Migration[8.1]
  def change
    remove_index :properties, :neighborhood, if_exists: true
    remove_column :properties, :neighborhood, :string
    add_reference :properties, :neighborhood, null: false, foreign_key: true
  end
end