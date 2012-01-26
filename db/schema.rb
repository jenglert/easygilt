# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120126182804) do

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_sku_attributes", :force => true do |t|
    t.integer  "product_sku_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_skus", :force => true do |t|
    t.integer  "product_id"
    t.decimal  "msrp_price"
    t.decimal  "sale_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.string   "brand"
    t.text     "description"
    t.text     "fit_notes"
    t.string   "material"
    t.string   "origin"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
