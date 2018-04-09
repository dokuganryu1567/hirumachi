class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  
  validates :shop_name, presence: true, length: { maximum: 50 }
  validates :congestion, presence: true
  
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode
end
