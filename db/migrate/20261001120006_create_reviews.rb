class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :property, null: false, foreign_key: true
      t.references :seeker, null: false, foreign_key: { to_table: :users }
      t.integer :rating, null: false
      t.text :comment

      t.timestamps
    end

    add_index :reviews, [:property_id, :seeker_id], unique: true, name: "index_reviews_on_property_and_seeker"
  end
end