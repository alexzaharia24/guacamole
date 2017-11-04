class CreateParkSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :park_spots do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.string :address
      t.float :latitude
      t.float :longitude
      t.float :price_per_hour
      t.integer :size
      t.string :description

      t.timestamps
    end
  end
end
