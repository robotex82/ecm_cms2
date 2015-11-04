module Ecm
  module Cms
    class Routing
      def self.routes(router, options = {})
        options.reverse_merge!({})

        router.get "/*page", :to => "ecm/cms/page#respond", :as => :page
        router.get '/' => "ecm/cms/page#respond", :page => 'home' #, :as => :root
      end
    end
  end
end

