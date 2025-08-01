class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User', foreign_key: 'follower_user_id'
  belongs_to :followed, class_name: 'User', foreign_key: 'followed_user_id'

  validates :follower_user_id, uniqueness: {scope: :followed_user_id}
end
