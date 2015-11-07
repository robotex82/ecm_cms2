class AddPropertiesToEcmCmsNavigationItems < ActiveRecord::Migration
  def change
    add_column :ecm_cms_navigation_items, :properties, :text, null: true
  end
end
