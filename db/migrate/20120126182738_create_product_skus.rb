class CreateProductSkus < ActiveRecord::Migration
  def self.up
    create_table :product_skus do |t|
      t.integer :product_id
      t.decimal :msrp_price
      t.decimal :sale_price

      t.timestamps
    end
  end

  def self.down
    drop_table :product_skus
  end
end
