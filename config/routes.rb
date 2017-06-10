Ecm::Cms::Engine.routes.draw do
  get '/*page', to: 'page#respond', as: :page
  get '/',      to: 'page#respond', page: 'home'
end
