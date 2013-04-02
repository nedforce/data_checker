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

ActiveRecord::Schema.define(:version => 20130402112740) do

  create_table "data_warnings", :force => true do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.string   "error_code"
    t.text     "message"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "data_warnings", ["error_code"], :name => "index_data_warnings_on_error_code"
  add_index "data_warnings", ["status"], :name => "index_data_warnings_on_status"
  add_index "data_warnings", ["subject_id", "subject_type"], :name => "index_data_warnings_on_subject_id_and_subject_type"

  create_table "nodes", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "body2"
    t.datetime "last_checked_at"
  end

end
