class DropStrayItemAndUnitTables < ActiveRecord::Migration[8.1]
  def change
    drop_table :units do |t|
      t.string :asset_tag, null: false
      t.bigint :item_model_id
      t.timestamps
    end

    drop_table :item_models do |t|
      t.string :brand, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end