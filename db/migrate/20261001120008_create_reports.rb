class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.references :reporter, null: false, foreign_key: { to_table: :users }
      t.references :listing, null: false, foreign_key: true
      t.string :reason, null: false
      t.text :details
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :reports, :status
  end
end