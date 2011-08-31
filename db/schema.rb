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

ActiveRecord::Schema.define(:version => 20110831001330) do

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.float    "hfi_rate"
    t.boolean  "hfi_prime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "load_details", :force => true do |t|
    t.integer "ticket_id"
    t.integer "species_id"
    t.integer "measure_type"
    t.float   "amount"
  end

  create_table "logger_assignments", :force => true do |t|
    t.integer  "job_id"
    t.integer  "partner_id"
    t.float    "rate_mbf"
    t.float    "rate_percent"
    t.float    "rate_tonnage"
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
    t.date     "payment_date"
    t.integer  "payment_no"
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
    t.integer  "logger_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.date     "receipt_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipts_tickets", :id => false, :force => true do |t|
    t.integer "receipt_id"
    t.integer "ticket_id"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "destination_id"
    t.integer  "job_id"
    t.integer  "number"
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
    t.integer "destination_id"
    t.integer "job_id"
    t.integer "partner_id"
    t.float   "rate"
  end

end
