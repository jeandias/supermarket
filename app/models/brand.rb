class Brand < ApplicationRecord
  has_many :products

  validates_uniqueness_of :name, :allow_blank => false
end
