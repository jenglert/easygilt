class CreateProductHotVotes < ActiveRecord::Migration
  def self.up
    create_table :product_hot_votes do |t|
      t.integer :product_id
      t.boolean :is_winner
      t.timestamps
    end
  end

  def self.down
    drop_table :product_hot_votes
  end
end
