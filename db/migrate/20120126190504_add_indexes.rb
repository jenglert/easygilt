class AddIndexes < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute("create index products_name_idx on products(name)")
    ActiveRecord::Base.connection.execute("create index products_description_idx on products USING gin(to_tsvector('english', description))")
    ActiveRecord::Base.connection.execute("create index products_brand_idx on products(brand)")
    ActiveRecord::Base.connection.execute("create index products_sku_attributes_value_idx on product_sku_attributes(value)")
  end

  def self.down
  end
end
