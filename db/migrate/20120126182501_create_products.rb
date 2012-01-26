class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :brand
      t.text :description
      t.text :fit_notes
      t.string :material
      t.string :origin
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
