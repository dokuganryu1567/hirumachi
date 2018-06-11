class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  
  validates :shop_name, presence: true, length: { maximum: 50 }
  validates :congestion, presence: true
  validates :image, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
  
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
