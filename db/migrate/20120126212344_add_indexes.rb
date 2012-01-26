class AddIndexes < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.connection.execute("create index search_terms_key_idx on search_terms(term)")

  end

  def self.down
  end
end
