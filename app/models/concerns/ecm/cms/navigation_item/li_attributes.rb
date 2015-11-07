require 'active_support/concern'

module Ecm::Cms
  module NavigationItem::LiAttributes
    extend ActiveSupport::Concern

    included do
      serialize :properties, OpenStruct
      delegate *Configuration.navigation_item_properties, to: :li_attributes
      delegate *Configuration.navigation_item_properties.collect { |a| "#{a}=".to_sym }, to: :li_attributes
    end

    def li_attributes
      self.properties.li_attributes ||= OpenStruct.new
    end

    def li_attributes=(li_attributes)
      properties.li_attributes = li_attributes
    end
  end
end