namespace :ecm do
  namespace :cms do
    desc 'Imports partials from app/views into the database'
    task :import_partials, [:view_path, :force] => [:environment] do |_t, args|
      args.with_defaults(view_path: Rails.root.join(*%(app views)), force: false)
      Ecm::Cms::ImportPartialsService.call(args)
    end
  end
end
