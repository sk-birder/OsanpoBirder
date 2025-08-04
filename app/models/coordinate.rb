class Coordinate < ApplicationRecord
  belongs_to :post

  # geocoded_by :column
  # after_validation :geocode
end
