class Product < ActiveRecord::Base
  has_many :product_images
  has_many :product_skus
  has_many :product_hot_votes

  def top_three_images
    product_images[0..2]
  end

  def sizes
    sizes = []
    product_skus.each do |product_sku|
      product_sku.product_sku_attributes.each do |attribute|
        sizes << attribute.value if attribute.name == 'size'
      end
    end
    sizes.uniq
  end

  def size_string
    sizes.join(', ')
  end

  def colors
    colors = []
    product_skus.each do |product_sku|
      product_sku.product_sku_attributes.each do |attribute|
        colors << attribute.value if attribute.name == 'color'
      end
    end
    colors.uniq
  end

  def colors_string
    colors.join(', ')
  end

end
