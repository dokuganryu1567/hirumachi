class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
                    uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :posts
  
  def feed_posts
    Post.where(user_id: self.post_ids + [self.id])
  end
end
