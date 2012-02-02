class AddHeightWidthSetNameToProductImages < ActiveRecord::Migration
  def self.up
    add_column :product_images, :set_name, :string
    add_column :product_images, :height, :integer, :default => 0, :null => false
    add_column :product_images, :width, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :product_images, :set_name
    remove_column :product_images, :height
    remove_column :product_images, :width
  end
end
