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

ActiveRecord::Schema.define(:version => 20110921161616) do

  create_table "addresses", :force => true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "zip_code"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_people", :force => true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "destinations", :force => true do |t|
    t.integer  "address_id"
    t.integer  "contact_person_id"
    t.string   "accepted_load_type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.string   "owner_id"
    t.float    "hfi_rate"
    t.boolean  "hfi_prime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "load_details", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "species_id"
    t.string   "load_type"
    t.float    "tonnage"
    t.float    "mbfs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logger_assignments", :force => true do |t|
    t.integer  "job_id"
    t.integer  "partner_id"
    t.boolean  "pay_the_trucker"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logger_rates", :force => true do |t|
    t.integer  "destination_id"
    t.integer  "job_id"
    t.integer  "partner_id"
    t.float    "rate"
    t.boolean  "is_percent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "owners", :force => true do |t|
    t.integer  "address_id"
    t.integer  "contact_person_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", :force => true do |t|
    t.integer  "address_id"
    t.integer  "contact_person_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_from_destinations", :force => true do |t|
    t.integer  "destination_id"
    t.integer  "job_id"
    t.string   "load_type"
    t.date     "payment_date"
    t.string   "payment_num"
    t.float    "tonnage"
    t.integer  "tickets"
    t.float    "total_payment"
    t.float    "net_mbf"
    t.integer  "wood_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipt_items", :force => true do |t|
    t.string   "item_data"
    t.integer  "receipt_id"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipts", :force => true do |t|
    t.integer  "job_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "payment_num"
    t.string   "notes"
    t.date     "receipt_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipts_tickets", :id => false, :force => true do |t|
    t.integer "receipt_id"
    t.integer "ticket_id"
  end

  create_table "species", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.date     "delivery_date"
    t.integer  "destination_id"
    t.integer  "job_id"
    t.integer  "number"
    t.integer  "wood_type"
    t.boolean  "paid_to_owner"
    t.boolean  "paid_to_logger"
    t.boolean  "paid_to_trucker"
    t.float    "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucker_assignments", :force => true do |t|
    t.integer  "job_id"
    t.integer  "partner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucker_rates", :force => true do |t|
    t.integer  "destination_id"
    t.integer  "job_id"
    t.integer  "partner_id"
    t.float    "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wood_types", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
