# This migration comes from ecm_cms_engine (originally 9)
class AddPropertiesToEcmCmsNavigationItems < ActiveRecord::Migration
  def change
    add_column :ecm_cms_navigation_items, :properties, :text, null: true
  end
end
