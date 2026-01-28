class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: {maximum:1000}

  scope :recent, -> { order(created_at: :desc)}

  def display_main_datetime
    created_at.strftime('%Y/%m/%d %H:%M')
  end
end
