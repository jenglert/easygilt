class AddStore < ActiveRecord::Migration
  def self.up
    add_column :products, :store, :string
  end

  def self.down
  end
end
