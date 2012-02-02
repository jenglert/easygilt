class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name, :limit => 1000
      t.string :brand, :limit => 1000
      t.text :description
      t.text :fit_notes
      t.string :material, :limit => 1000
      t.string :origin, :limit => 1000
      t.string :url, :limit => 1000

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
