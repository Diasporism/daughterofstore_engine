# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130430032017) do

  create_table "auctions", :force => true do |t|
    t.integer  "store_id"
    t.integer  "starting_bid"
    t.string   "shipping_options"
    t.boolean  "active",           :default => true
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "expiration_date"
  end

  add_index "auctions", ["store_id"], :name => "index_auctions_on_store_id"

  create_table "bids", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "bids", ["auction_id"], :name => "index_bids_on_auction_id"
  add_index "bids", ["user_id"], :name => "index_bids_on_user_id"

  create_table "billing_addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "order_id"
  end

  add_index "billing_addresses", ["order_id"], :name => "index_billing_addresses_on_order_id"

  create_table "order_events", :force => true do |t|
    t.string   "status"
    t.integer  "order_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_events", ["order_id"], :name => "index_order_events_on_order_id"

  create_table "orders", :force => true do |t|
    t.integer  "total_price",     :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "store_id"
    t.string   "random_order_id"
  end

  add_index "orders", ["store_id"], :name => "index_orders_on_store_id"

  create_table "payment_options", :force => true do |t|
    t.integer  "auction_id"
    t.string   "payment_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "payment_options", ["auction_id"], :name => "index_payment_options_on_auction_id"

  create_table "products", :force => true do |t|
    t.string   "title",                                :null => false
    t.text     "description",                          :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "active",             :default => true
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "slug"
    t.string   "photo_url"
    t.integer  "auction_id"
  end

  add_index "products", ["slug"], :name => "index_products_on_slug"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "shipping_addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "order_id"
  end

  add_index "shipping_addresses", ["order_id"], :name => "index_shipping_addresses_on_order_id"

  create_table "stores", :force => true do |t|
    t.string "name"
    t.string "path"
    t.string "description"
    t.string "status"
  end

  create_table "user_store_roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "store_id"
    t.string   "role"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_store_roles", ["store_id", "user_id"], :name => "index_user_store_roles_on_store_id_and_user_id", :unique => true
  add_index "user_store_roles", ["user_id"], :name => "index_user_store_roles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "display_name"
    t.boolean  "super_admin",     :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest",                    :null => false
    t.string   "full_name",                          :null => false
    t.string   "customer_id"
    t.string   "last_4_digits"
  end

  add_index "users", ["id"], :name => "index_users_on_id"

end
