class AddPercentageToSearchTerms < ActiveRecord::Migration
  def self.up
    add_column :search_terms, :percentage, :float
  end

  def self.down
  end
end
