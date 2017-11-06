class CreateAvailabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :availabilities do |t|
      t.date :date
      t.time :start_time
      t.time :end_time
      t.references :park_spot

      t.timestamps
    end
  end
end
