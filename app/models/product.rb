class Product < ActiveRecord::Base
  has_many :product_images, :dependent => :destroy
  has_many :product_skus, :dependent => :destroy
  has_many :product_hot_votes, :dependent => :destroy

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

  def large_images
    set_name = product_images.sort_by{ |image| image.height * image.width }.last.set_name
    product_images.select{ |image| image.set_name == set_name }
  end

end
