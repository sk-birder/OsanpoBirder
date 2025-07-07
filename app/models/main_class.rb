class MainClass < ApplicationRecord
  has_many :sub_classes
  has_many :posts
end
