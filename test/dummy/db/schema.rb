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

ActiveRecord::Schema.define(version: 20140513180315) do

  create_table "momentum_cms_block_translations", force: true do |t|
    t.integer  "momentum_cms_block_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "value"
  end

  add_index "momentum_cms_block_translations", ["locale"], name: "index_momentum_cms_block_translations_on_locale"
  add_index "momentum_cms_block_translations", ["momentum_cms_block_id"], name: "index_momentum_cms_block_translations_on_momentum_cms_block_id"

  create_table "momentum_cms_blocks", force: true do |t|
    t.integer  "content_id"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_blocks", ["content_id"], name: "index_momentum_cms_blocks_on_content_id"

  create_table "momentum_cms_content_translations", force: true do |t|
    t.integer  "momentum_cms_content_id", null: false
    t.string   "locale",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
    t.text     "content"
  end

  add_index "momentum_cms_content_translations", ["locale"], name: "index_momentum_cms_content_translations_on_locale"
  add_index "momentum_cms_content_translations", ["momentum_cms_content_id"], name: "index_f568390e5943e526d13e1fe618dba0f7bd86e30f"

  create_table "momentum_cms_contents", force: true do |t|
    t.boolean  "default"
    t.integer  "page_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_contents", ["page_id"], name: "index_momentum_cms_contents_on_page_id"
  add_index "momentum_cms_contents", ["template_id"], name: "index_momentum_cms_contents_on_template_id"

  create_table "momentum_cms_files", force: true do |t|
    t.string   "label"
    t.string   "tag"
    t.string   "slug"
    t.boolean  "multiple",          default: false
    t.integer  "site_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "momentum_cms_files", ["site_id"], name: "index_momentum_cms_files_on_site_id"

  create_table "momentum_cms_locales", force: true do |t|
    t.string "label"
    t.string "identifier"
  end

  create_table "momentum_cms_menu_items", force: true do |t|
    t.integer  "menu_id"
    t.string   "ancestry"
    t.integer  "menu_item_type"
    t.integer  "linkable_id"
    t.string   "linkable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_menu_items", ["menu_id"], name: "index_momentum_cms_menu_items_on_menu_id"

  create_table "momentum_cms_menus", force: true do |t|
    t.integer  "site_id"
    t.string   "label"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_menus", ["site_id"], name: "index_momentum_cms_menus_on_site_id"

  create_table "momentum_cms_page_translations", force: true do |t|
    t.integer  "momentum_cms_page_id", null: false
    t.string   "locale",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
    t.string   "path"
  end

  add_index "momentum_cms_page_translations", ["locale"], name: "index_momentum_cms_page_translations_on_locale"
  add_index "momentum_cms_page_translations", ["momentum_cms_page_id"], name: "index_momentum_cms_page_translations_on_momentum_cms_page_id"

  create_table "momentum_cms_pages", force: true do |t|
    t.integer  "site_id"
    t.integer  "template_id"
    t.string   "label"
    t.integer  "published_content_id"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_pages", ["site_id"], name: "index_momentum_cms_pages_on_site_id"
  add_index "momentum_cms_pages", ["template_id"], name: "index_momentum_cms_pages_on_template_id"

  create_table "momentum_cms_sites", force: true do |t|
    t.string   "identifier"
    t.string   "label"
    t.string   "host"
    t.string   "setting_title"
    t.text     "setting_locales"
    t.text     "setting_default_locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "momentum_cms_snippet_translations", force: true do |t|
    t.integer  "momentum_cms_snippet_id", null: false
    t.string   "locale",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "value"
  end

  add_index "momentum_cms_snippet_translations", ["locale"], name: "index_momentum_cms_snippet_translations_on_locale"
  add_index "momentum_cms_snippet_translations", ["momentum_cms_snippet_id"], name: "index_bd8a9f04a5a4cbeeed7124c8d72aa2af32b58076"

  create_table "momentum_cms_snippets", force: true do |t|
    t.integer  "site_id"
    t.string   "label"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_snippets", ["site_id"], name: "index_momentum_cms_snippets_on_site_id"

  create_table "momentum_cms_templates", force: true do |t|
    t.string   "label"
    t.integer  "site_id"
    t.text     "content"
    t.text     "js"
    t.text     "css"
    t.string   "ancestry"
    t.boolean  "permanent_record", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_templates", ["site_id"], name: "index_momentum_cms_templates_on_site_id"

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.string   "locale"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
