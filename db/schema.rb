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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140829121936) do

  create_table "custom_avatars", force: true do |t|
    t.string   "name"
    t.integer  "uploader"
    t.string   "author"
    t.text     "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
  end

  create_table "custom_pet_templates", force: true do |t|
    t.string   "name",                            null: false
    t.integer  "uploader",                        null: false
    t.integer  "recipient"
    t.string   "author",                          null: false
    t.string   "rights",     default: "reserved", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
  end

  create_table "favor_transactions", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "forums", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hour_logs", force: true do |t|
    t.integer  "pet_id",                      null: false
    t.string   "description",                 null: false
    t.boolean  "real_time",   default: false, null: false
    t.integer  "hour",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hour_logs", ["pet_id"], name: "index_hour_logs_on_pet_id", using: :btree

  create_table "houses", force: true do |t|
    t.integer  "user_id"
    t.datetime "last_hour_run",     default: '2013-12-08 16:40:44', null: false
    t.integer  "current_bulk",      default: 0,                     null: false
    t.integer  "max_bulk",          default: 100,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "allowance_hours",   default: 0,                     null: false
    t.boolean  "display_hour_logs", default: true,                  null: false
  end

  create_table "internal_mails", force: true do |t|
    t.integer  "from_user_id",                   null: false
    t.integer  "to_user_id",                     null: false
    t.boolean  "read",           default: false, null: false
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from_user_name",                 null: false
    t.string   "to_user_name",                   null: false
  end

  create_table "item_templates", force: true do |t|
    t.string   "name"
    t.text     "description",         limit: 16777215
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "edible",                               default: false,  null: false
    t.integer  "edible_size"
    t.integer  "value",                                default: 1,      null: false
    t.boolean  "is_equipment",                         default: false,  null: false
    t.integer  "equip_crafting",                       default: 0,      null: false
    t.integer  "equip_gathering",                      default: 0,      null: false
    t.integer  "equip_mining",                         default: 0,      null: false
    t.integer  "equip_hunting",                        default: 0,      null: false
    t.integer  "equip_smithing",                       default: 0,      null: false
    t.integer  "equip_intelligence",                   default: 0,      null: false
    t.integer  "equip_dexterity",                      default: 0,      null: false
    t.integer  "equip_strength",                       default: 0,      null: false
    t.integer  "equip_perception",                     default: 0,      null: false
    t.integer  "equip_stamina",                        default: 0,      null: false
    t.integer  "equip_athletics",                      default: 0,      null: false
    t.integer  "durability"
    t.integer  "equip_thieving",                       default: 0,      null: false
    t.integer  "equip_fishing",                        default: 0,      null: false
    t.integer  "equip_lumberjacking",                  default: 0,      null: false
    t.integer  "equip_stealth",                        default: 0,      null: false
    t.integer  "equip_wits",                           default: 0,      null: false
    t.string   "recycle_ingredients"
    t.boolean  "has_action",                           default: false,  null: false
    t.string   "extension",                            default: ".png", null: false
  end

  create_table "item_trades", force: true do |t|
    t.integer  "user_1_id",                     null: false
    t.integer  "user_2_id",                     null: false
    t.boolean  "anonymous",     default: false, null: false
    t.boolean  "gift",          default: false, null: false
    t.boolean  "negotiated",    default: false, null: false
    t.text     "item_1_ids"
    t.text     "item_2_ids"
    t.integer  "money_1",       default: 0,     null: false
    t.integer  "money_2",       default: 0,     null: false
    t.string   "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",        default: 0,     null: false
    t.text     "description_1"
    t.text     "description_2"
  end

  create_table "items", force: true do |t|
    t.integer  "item_template_id"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "price"
    t.integer  "location",         default: 0, null: false
    t.string   "origin_note"
    t.string   "user_note"
    t.integer  "room",             default: 0, null: false
    t.integer  "health"
    t.integer  "pet_id"
  end

  add_index "items", ["user_id", "location"], name: "index_items_on_user_id_and_location", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name",                              null: false
    t.integer  "level",       default: 1,           null: false
    t.string   "prizes",      default: "",          null: false
    t.string   "category",    default: "gathering", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "article",     default: "a",         null: false
    t.string   "preposition", default: "at",        null: false
  end

  create_table "makeables", force: true do |t|
    t.integer  "difficulty",       default: 1,  null: false
    t.integer  "item_template_id",              null: false
    t.string   "ingredients",      default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity",         default: 1,  null: false
  end

  create_table "pattern_tiles", force: true do |t|
    t.integer  "x",           null: false
    t.integer  "y",           null: false
    t.integer  "treasure_id"
    t.integer  "obstacle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tile",        null: false
  end

  create_table "pattern_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "x"
    t.integer  "y"
    t.datetime "last_overview_look"
  end

  create_table "pet_badges", force: true do |t|
    t.integer  "pet_id",                            null: false
    t.boolean  "master_thief",      default: false, null: false
    t.boolean  "master_gatherer",   default: false, null: false
    t.boolean  "master_lumberjack", default: false, null: false
    t.boolean  "master_crafter",    default: false, null: false
    t.boolean  "master_miner",      default: false, null: false
    t.boolean  "master_fisher",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pet_reincarnations", force: true do |t|
    t.integer  "pet_id",          null: false
    t.datetime "reincarnated_on", null: false
    t.datetime "born_on",         null: false
    t.string   "masteries",       null: false
    t.integer  "level",           null: false
    t.string   "graphic",         null: false
    t.datetime "created_at",      null: false
  end

  create_table "pets", force: true do |t|
    t.string   "name",                              null: false
    t.datetime "birthday",                          null: false
    t.boolean  "gender",                            null: false
    t.integer  "user_id",                           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pet_template_id"
    t.string   "pet_template_type"
    t.boolean  "sleeping",          default: false, null: false
    t.integer  "food",              default: 5,     null: false
    t.integer  "energy",            default: 5,     null: false
    t.float    "stamina",           default: 0.0,   null: false
    t.float    "strength",          default: 0.0,   null: false
    t.float    "intelligence",      default: 0.0,   null: false
    t.float    "dexterity",         default: 0.0,   null: false
    t.float    "perception",        default: 0.0,   null: false
    t.float    "crafting",          default: 0.0,   null: false
    t.float    "gathering",         default: 0.0,   null: false
    t.float    "athletics",         default: 0.0,   null: false
    t.float    "survival",          default: 0.0,   null: false
    t.float    "mining",            default: 0.0,   null: false
    t.float    "smithing",          default: 0.0,   null: false
    t.float    "stealth",           default: 0.0,   null: false
    t.float    "fishing",           default: 0.0,   null: false
    t.float    "wits",              default: 0.0,   null: false
    t.float    "thieving",          default: 0.0,   null: false
    t.float    "lumberjacking",     default: 0.0,   null: false
    t.text     "profile"
    t.boolean  "master_gatherer",   default: false, null: false
    t.boolean  "master_thief",      default: false, null: false
    t.boolean  "master_fisher",     default: false, null: false
    t.boolean  "master_crafter",    default: false, null: false
    t.boolean  "master_lumberjack", default: false, null: false
    t.boolean  "master_miner",      default: false, null: false
  end

  create_table "posts", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "topic_id"
    t.integer  "user_id"
    t.integer  "stars",      default: 0, null: false
    t.string   "action"
  end

  add_index "posts", ["topic_id"], name: "index_posts_on_topic_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "recipes", force: true do |t|
    t.string   "ingredients"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "results",     null: false
  end

  create_table "standard_avatars", force: true do |t|
    t.string   "name"
    t.text     "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
  end

  create_table "standard_pet_templates", force: true do |t|
    t.string   "name",       null: false
    t.text     "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "extension"
  end

  create_table "star_logs", force: true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.integer  "author_id"
    t.integer  "count"
    t.boolean  "new"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "store_transactions", force: true do |t|
    t.integer  "user_id"
    t.string   "description"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: true do |t|
    t.string   "name"
    t.integer  "last_poster_id"
    t.datetime "last_post_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.integer  "user_id"
    t.integer  "first_post_id"
    t.boolean  "stickied",       default: false, null: false
    t.string   "icon"
  end

  create_table "user_badges", force: true do |t|
    t.integer  "user_id",                        null: false
    t.boolean  "raining_garlic", default: false, null: false
    t.boolean  "raining_bacon",  default: false, null: false
    t.boolean  "baconado",       default: false, null: false
    t.boolean  "orng",           default: false, null: false
    t.datetime "created_at"
  end

  create_table "user_statistics", force: true do |t|
    t.integer  "user_id",                                   null: false
    t.integer  "gifted_items",                  default: 0, null: false
    t.integer  "maze_pieces_placed",            default: 0, null: false
    t.integer  "hand_fet_pets",                 default: 0, null: false
    t.integer  "money_from_gameselling",        default: 0, null: false
    t.integer  "items_gamesold",                default: 0, null: false
    t.integer  "items_recycled",                default: 0, null: false
    t.integer  "items_received_from_recycling", default: 0, null: false
    t.integer  "recipes_made",                  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pattern_obstacles_cleared",     default: 0, null: false
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.datetime "password_date",          default: '2013-12-03 01:20:36', null: false
    t.string   "display_name"
    t.string   "email",                                                  null: false
    t.boolean  "is_admin",               default: false,                 null: false
    t.integer  "money",                  default: 500,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "is_npc",                 default: false,                 null: false
    t.integer  "avatar_id"
    t.string   "avatar_type"
    t.datetime "last_adopt"
    t.float    "savings",                default: 0.0,                   null: false
    t.string   "time_zone"
    t.integer  "favor",                  default: 0,                     null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "stars",                  default: 0,                     null: false
    t.boolean  "has_unseen_mail",        default: false,                 null: false
    t.datetime "last_active"
    t.boolean  "city_hall_notice",       default: false,                 null: false
    t.boolean  "has_new_sales",          default: false,                 null: false
    t.text     "profile"
    t.boolean  "has_new_stars",          default: false,                 null: false
    t.boolean  "trade_notice",           default: false,                 null: false
    t.integer  "karma",                  default: 0,                     null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
