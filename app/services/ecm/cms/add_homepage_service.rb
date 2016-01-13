module Ecm::Cms
  class AddHomepageService
    def self.call(*args)
      new(*args).do_work
    end

    def initialize(options = {})
      options.reverse_merge!({ locales: I18n.available_locales })
      @locales = options[:locales]
      @all_pages = []
      @already_existent_pages = []
      @failed_pages = []
      @created_pages = []

    end

    def do_work
      puts "Environment: #{Rails.env}"
      create_homepages
      puts "  Skipped #{@already_existent_pages.size} already existent pages for locales: #{@already_existent_pages.map(&:locale).join(', ')}"
      puts "  Added #{@created_pages.size} new home pages for locales: #{@created_pages.map(&:locale).join(', ')}"
      puts "  Failed adding #{@failed_pages.size} new home pages for locales: #{@failed_pages.map(&:locale).join(', ')}"
    end

    private

    def create_homepages
      @all_pages = @locales.collect do |locale|
        puts "  Adding homepage for locale #{locale}"
        page = Ecm::Cms::Page.where(locale: locale, pathname: '/', basename: 'home', handler: 'textile').first_or_initialize
        unless page.new_record?
          @already_existent_pages << page
          puts "    already exists"
          next page
        end 
        page.tap do |page|
          page.title            = "Homepage (#{locale})"
          page.meta_description = 'home'
          page.body             = "h1. Homepage (#{locale})"
          page.pathname         = '/'
          page.basename         = 'home'
          page.locale           = locale
          page.handler          = 'textile'
        end
        if page.save
          @created_pages << page
          puts "    done"
        else
          @failed_pages << page
          puts "could not save page. errors: #{page.errors.full_messages.to_sentence}"
        end
        page
      end
    end
  end
end
