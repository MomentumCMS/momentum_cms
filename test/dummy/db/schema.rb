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

ActiveRecord::Schema.define(version: 20140607222870) do

  create_table "momentum_cms_api_keys", force: true do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "scope"
    t.datetime "expired_at"
    t.datetime "created_at"
  end

  add_index "momentum_cms_api_keys", ["access_token"], name: "index_momentum_cms_api_keys_on_access_token", unique: true

  create_table "momentum_cms_block_template_translations", force: true do |t|
    t.integer  "momentum_cms_block_template_id", null: false
    t.string   "locale",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  add_index "momentum_cms_block_template_translations", ["locale"], name: "index_momentum_cms_block_template_translations_on_locale"
  add_index "momentum_cms_block_template_translations", ["momentum_cms_block_template_id"], name: "index_7d8345f3f68f4b0f664f39205fcbfea7bb7c7e47"

  create_table "momentum_cms_block_templates", force: true do |t|
    t.integer  "template_id"
    t.string   "identifier"
    t.string   "block_type"
    t.string   "block_value_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_block_templates", ["template_id"], name: "index_momentum_cms_block_templates_on_template_id"

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
    t.integer  "block_template_id"
    t.integer  "page_id"
    t.string   "identifier"
    t.string   "block_type"
    t.integer  "revision_block_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_blocks", ["block_template_id"], name: "index_momentum_cms_blocks_on_block_template_id"
  add_index "momentum_cms_blocks", ["page_id"], name: "index_momentum_cms_blocks_on_page_id"

  create_table "momentum_cms_blue_print_translations", force: true do |t|
    t.integer  "momentum_cms_blue_print_id", null: false
    t.string   "locale",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  add_index "momentum_cms_blue_print_translations", ["locale"], name: "index_momentum_cms_blue_print_translations_on_locale"
  add_index "momentum_cms_blue_print_translations", ["momentum_cms_blue_print_id"], name: "index_5cbeb924121db6119fc50007398dfaa141ea69f8"

  create_table "momentum_cms_blue_prints", force: true do |t|
    t.integer  "site_id"
    t.string   "identifier"
    t.string   "ancestry"
    t.boolean  "permanent_record", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_blue_prints", ["site_id"], name: "index_momentum_cms_blue_prints_on_site_id"

  create_table "momentum_cms_document_translations", force: true do |t|
    t.integer  "momentum_cms_document_id", null: false
    t.string   "locale",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  add_index "momentum_cms_document_translations", ["locale"], name: "index_momentum_cms_document_translations_on_locale"
  add_index "momentum_cms_document_translations", ["momentum_cms_document_id"], name: "index_de85ac2fea54df8b1afdbd7dbae66e1f0b624477"

  create_table "momentum_cms_documents", force: true do |t|
    t.integer  "blue_print_id"
    t.integer  "site_id"
    t.string   "identifier"
    t.boolean  "published",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_documents", ["blue_print_id"], name: "index_momentum_cms_documents_on_blue_print_id"
  add_index "momentum_cms_documents", ["site_id"], name: "index_momentum_cms_documents_on_site_id"

  create_table "momentum_cms_field_template_translations", force: true do |t|
    t.integer  "momentum_cms_field_template_id", null: false
    t.string   "locale",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  add_index "momentum_cms_field_template_translations", ["locale"], name: "index_momentum_cms_field_template_translations_on_locale"
  add_index "momentum_cms_field_template_translations", ["momentum_cms_field_template_id"], name: "index_0476773c64ff1b030b685e0c382f95185c83776f"

  create_table "momentum_cms_field_templates", force: true do |t|
    t.integer  "blue_print_id"
    t.string   "identifier"
    t.string   "field_value_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_field_templates", ["blue_print_id"], name: "index_momentum_cms_field_templates_on_blue_print_id"

  create_table "momentum_cms_field_translations", force: true do |t|
    t.integer  "momentum_cms_field_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "value"
  end

  add_index "momentum_cms_field_translations", ["locale"], name: "index_momentum_cms_field_translations_on_locale"
  add_index "momentum_cms_field_translations", ["momentum_cms_field_id"], name: "index_momentum_cms_field_translations_on_momentum_cms_field_id"

  create_table "momentum_cms_fields", force: true do |t|
    t.integer  "document_id"
    t.integer  "field_template_id"
    t.string   "identifier"
    t.string   "field_type"
    t.integer  "revision_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_fields", ["document_id"], name: "index_momentum_cms_fields_on_document_id"
  add_index "momentum_cms_fields", ["field_template_id"], name: "index_momentum_cms_fields_on_field_template_id"

  create_table "momentum_cms_files", force: true do |t|
    t.string   "label"
    t.string   "tag"
    t.string   "identifier"
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

  create_table "momentum_cms_link_translations", force: true do |t|
    t.integer  "momentum_cms_link_id", null: false
    t.string   "locale",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "label"
    t.text     "description"
  end

  add_index "momentum_cms_link_translations", ["locale"], name: "index_momentum_cms_link_translations_on_locale"
  add_index "momentum_cms_link_translations", ["momentum_cms_link_id"], name: "index_momentum_cms_link_translations_on_momentum_cms_link_id"

  create_table "momentum_cms_links", force: true do |t|
    t.integer  "site_id"
    t.string   "identifier"
    t.string   "url"
    t.string   "target"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_links", ["site_id"], name: "index_momentum_cms_links_on_site_id"

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
    t.string   "identifier"
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
    t.string   "label"
  end

  add_index "momentum_cms_page_translations", ["locale"], name: "index_momentum_cms_page_translations_on_locale"
  add_index "momentum_cms_page_translations", ["momentum_cms_page_id"], name: "index_momentum_cms_page_translations_on_momentum_cms_page_id"

  create_table "momentum_cms_pages", force: true do |t|
    t.integer  "site_id"
    t.integer  "template_id"
    t.string   "identifier"
    t.integer  "redirected_page_id"
    t.string   "ancestry"
    t.boolean  "published",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_pages", ["site_id"], name: "index_momentum_cms_pages_on_site_id"
  add_index "momentum_cms_pages", ["template_id"], name: "index_momentum_cms_pages_on_template_id"

  create_table "momentum_cms_revisions", force: true do |t|
    t.integer  "revisable_id"
    t.string   "revisable_type"
    t.integer  "revision_number"
    t.string   "published_status"
    t.text     "revision_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_revisions", ["revisable_id", "revisable_type"], name: "momentum_cms_revisions_r_id_r_t"

  create_table "momentum_cms_sites", force: true do |t|
    t.string   "identifier"
    t.string   "label"
    t.string   "host"
    t.string   "title"
    t.text     "available_locales"
    t.string   "default_locale"
    t.boolean  "enable_advanced_features", default: false
    t.string   "remote_fixture_type"
    t.text     "remote_fixture_url"
    t.datetime "last_remote_synced_at"
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
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_snippets", ["site_id"], name: "index_momentum_cms_snippets_on_site_id"

  create_table "momentum_cms_templates", force: true do |t|
    t.string   "label"
    t.string   "identifier"
    t.integer  "site_id"
    t.text     "value"
    t.text     "admin_value"
    t.text     "js"
    t.text     "css"
    t.string   "ancestry"
    t.boolean  "has_yield",        default: false
    t.boolean  "permanent_record", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "momentum_cms_templates", ["site_id"], name: "index_momentum_cms_templates_on_site_id"

end
