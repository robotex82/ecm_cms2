namespace :ecm do
  namespace :cms do
    desc 'Imports partials from app/views into the database'
    task :import_partials, [:view_path] => [:environment] do |t, args|
      args.with_defaults(:view_path => Rails.root.join(*%(app views)))
      Ecm::Cms::ImportPartialsService.call(args)
    end
  end
end

