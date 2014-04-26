class AddTranslationTables < ActiveRecord::Migration

  def up
    MomentumCms::Page.create_translation_table! :slug => :string, :path => :string
    MomentumCms::Content.create_translation_table! :label => :string, :content => :text
  end

  def down
    MomentumCms::Page.drop_translation_table!
    MomentumCms::Content.drop_translation_table!
  end

end
