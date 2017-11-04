class ParkSpot < ApplicationRecord
  # TODO: add currency
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => [:address, :latitude, :longitude, :name, :size]
  enum size: [ :small, :medium, :compact, :large, :trucks ]

  validates_length_of :name, maximum: 100, minimum: 5, allow_nil: false, allow_blank: false
  validates_length_of :description, maximum: 1000, minimum: 50, allow_nil: false, allow_blank: false

  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :address
  validates_presence_of :size
  validates_presence_of :price_per_hour
  validates_presence_of :name
end
