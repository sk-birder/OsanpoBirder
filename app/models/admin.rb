class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image

  has_many :boards,         dependent: :destroy
  has_many :board_comments, dependent: :destroy

  validates :name, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: {maximum: 200}
end
