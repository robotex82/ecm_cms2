class Ecm::Cms::Template < ActiveRecord::Base
  # add shared behaviour for database backed templates
  include Ecm::Cms::DatabaseTemplate

  # associations
  belongs_to :ecm_cms_folder,
             :class_name => 'Ecm::Cms::Folder',
             :foreign_key => 'ecm_cms_folder_id'

  # callbacks
  before_validation :ensure_basename_starts_without_underscore, :if => Proc.new { |t| t.basename.present? }

  private

  def ensure_basename_starts_without_underscore
    self.basename.slice!(0) if self.basename.start_with?('_')
  end
end

