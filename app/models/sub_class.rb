class SubClass < ApplicationRecord
  belongs_to :main_class
  has_many :posts
end
