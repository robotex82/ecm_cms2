require 'ecm/cms/database_template'

class Ecm::Cms::Partial < ActiveRecord::Base
  # add shared behaviour for database backed templates
  include Ecm::Cms::DatabaseTemplate

  # callbacks
  before_validation :ensure_basename_starts_with_underscore, :if => Proc.new { |t| t.basename.present? }

  private

  def ensure_basename_starts_with_underscore
    self.basename.insert(0, '_') unless self.basename.start_with?('_')
  end
end

