class Ecm::Cms::PageController < Ecm::Cms::Configuration.base_controller.constantize
  # add the page resolver
  include Ecm::Cms::ControllerExtensions::PageResolver
  include Ecm::Cms::ControllerExtensions::PartialResolver

  # avoid error 500 on missing template
  rescue_from ActionView::MissingTemplate do
    respond_to do |format|
      format.html do
        render(file: "#{Rails.root}/public/404", formats: [:html],
               layout: false,
               status: 404
              )
      end
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def respond
    render template: params[:page]
  end
end
