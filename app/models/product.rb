class Product < ApplicationRecord
  belongs_to :brand

  validates_uniqueness_of :name, :allow_blank => false
end
