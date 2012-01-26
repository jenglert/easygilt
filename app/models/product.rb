class Product < ActiveRecord::Base
  has_many :product_images
  has_many :product_skus
end
