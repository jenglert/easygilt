class Product < ActiveRecord::Base
  has_many :product_images
  has_many :product_skus

  def top_three_images
    product_images[0..2]
  end

end
