class CreateApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :applications do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :seeker, null: false, foreign_key: { to_table: :users }
      t.date :move_in_date, null: false
      t.integer :duration_months
      t.text :message
      t.string :state, null: false, default: "pending"

      t.timestamps
    end

    add_index :applications, :state
    add_index :applications, [:listing_id, :seeker_id], unique: true, name: "index_applications_on_listing_and_seeker"
  end
end