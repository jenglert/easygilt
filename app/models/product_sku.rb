class ProductSku < ActiveRecord::Base
  belongs_to :product
  has_many :product_sku_attributes, :dependant => :destroy
end
