class Report < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: {scope: :post_id}

  enum detail: {
    confirmed: 0, # 見られました
    gone: 1,      # なくなりました
    violating: 2  # 違反投稿です
  }
end
