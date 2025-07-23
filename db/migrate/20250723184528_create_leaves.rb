class CreateLeaves < ActiveRecord::Migration[8.0]
  def change
    create_table :leaves do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.string :type
      t.text :reason
      t.string :status, default: "pending"

      t.timestamps
    end
  end
end
