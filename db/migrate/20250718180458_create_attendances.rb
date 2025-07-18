class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.datetime :clock_in
      t.datetime :clock_out
      t.decimal :total_hours

      t.timestamps
    end
  end
end
