class Board < ApplicationRecord
  belongs_to :admin
  has_many :board_comments

  validates :title, presence: true, length: {maximum:100}
  validates :body, presence: true, length: {maximum:1000}
end
