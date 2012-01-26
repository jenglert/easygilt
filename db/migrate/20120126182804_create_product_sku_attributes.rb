class CreateProductSkuAttributes < ActiveRecord::Migration
  def self.up
    create_table :product_sku_attributes do |t|
      t.integer :product_sku_id
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :product_sku_attributes
  end
end
