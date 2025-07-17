class BoardComment < ApplicationRecord
  belongs_to :user
  belongs_to :admin
  belongs_to :board

  validates :body, presence: true, length: {maximum:1000}
end
