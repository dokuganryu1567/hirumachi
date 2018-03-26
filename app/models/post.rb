class Post < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true, lesgth: { maximum: 50 }
  validates :congestion, present: true
end
