module Ecm::Cms
  class ImportPartialsService

    class PartialInFileSystem
      def initialize(filename, view_path)
        @filename = filename
        @view_path = view_path
      end

      def pathname
        @pathname ||= File.dirname(relative_filename)
      end

      def basename
        @basename ||= File.basename(relative_filename).split('.').first
      end

      def locale
        locale = File.basename(relative_filename).split('.')[-3]
        if I18n.available_locales.map(&:to_s).include?(locale)
          @locale ||= locale
        else
          nil
        end
      end

      def format
        format = File.basename(relative_filename).split('.')[-2]
        if Mime::SET.symbols.map(&:to_s).include?(format)
          @format ||= format
        else
          nil
        end
      end

      def handler
        handler = File.basename(relative_filename).split('.').last
        if ActionView::Template::Handlers.extensions.map(&:to_s).include?(handler)
          @handler ||= handler
        else
          nil
        end
      end

      def body
        File.read(@filename)
      end

      def to_partial_attributes_hash
        {
          pathname: pathname,
          basename: basename,
          locale:   locale,
          format:   format,
          handler:  handler,
          body:     body
        }
      end

      def human
        "#{relative_filename} (#{body.size} bytes)"
      end

      private

      def relative_filename
        @relative_filename ||= @filename.gsub(view_path.to_s, '')
      end

      def view_path
        @view_path
      end
    end

    def self.call(*args)
      new(*args).do_work
    end

    def initialize(options = {})
      options.reverse_merge!({ view_path: Rails.root.join(*%w(app views)) })
      @view_path = options[:view_path]
    end

    def do_work
      puts "Environment: #{Rails.env}"
      @partials = load_partials
      partials_count = @partials.size
      puts "Processing #{partials_count} partials in #{view_path}:"
      @partials.each_with_index do |partial, index|
        puts "  (#{index + 1}/#{partials_count}) #{partial.human}"
        partial = Partial.new(partial.to_partial_attributes_hash)
        if partial.save
          puts "    Created #{partial.human}"
        else
          puts "    Could not create #{partial.human}. Errors: #{partial.errors.full_messages}"
        end
      end
    end

    private

    def load_partials
      load_partials_absolute.collect { |file| PartialInFileSystem.new(file, view_path) }
    end

    def load_partials_absolute
      Dir.glob("#{view_path}/**/_*.*")
    end

    def view_path
      @view_path
    end
  end
end
