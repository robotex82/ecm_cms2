Ecm::Cms.configure do |config|
  # Set the default handler for pages, partials and templates
  #
  # Default:   config.default_handlers = {
  #              page:     :texterb,
  #              partial:  :texterb,
  #              template: :texterb
  #            }
  #
  config.default_handlers = {
    page:     :texterb,
    partial:  :texterb,
    template: :texterb
  }

  # Set the base controller for the page controller
  #
  # Default: config.base_controller = 'ApplicationController'
  #
  config.base_controller = 'ApplicationController'
end
