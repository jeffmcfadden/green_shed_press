require 'yaml'

module GSP
  class Site
    attr_reader :title, :base_url, :description, :metadata, :files

    attr_accessor :data_directory

    FILES_TO_SKIP = ["site.yml"]

    def initialize(config:, data_directory: nil)
      if config.is_a?(String)
        @data_directory = File.expand_path(File.dirname(config))
        config = YAML.load_file(config, symbolize_names: true)
      elsif config.is_a?(File)
        @data_directory = File.expand_path(File.dirname(config))
        config = YAML.load_file(config.path, symbolize_names: true)
      elsif config.is_a?(Hash)
        @data_directory = data_directory
      end

      @title = config[:title]
      @base_url = config[:base_url]
      @description = config[:description]
      @metadata = config[:metadata] || {}

      @collection_objects = {}
    end

    def load
      LOGGER.debug "Site#load"

      @files = []
      Dir.glob(File.join(self.data_directory, '**', '*')).each do |file|
        next if File.directory?(file)
        next if File.basename(file).start_with?(".")
        next if FILES_TO_SKIP.include?(File.basename(file))

        @files << GSPFile.new(path: file, site: self)
      end

      GSP.collection_object_types.each do |type|
        @collection_objects[type.name] = []
      end

      @files.each do |file|
        GSP.collection_object_types.each do |type|
          if type.has_collection_object?(file: file)
            collection_object = type.collection_object(file: file)
            @collection_objects[type.name] << collection_object
            break
          end
        end

        # Static files are a special case
        @collection_objects["GSP::StaticFile"] << GSP::StaticFile.collection_object(file: file)
      end

      true
    end

    def generate(output_directory:)
      @collection_objects.each do |type, objects|
        objects.each do |object|
          object.generate(output_directory: output_directory)
        end
      end
    end

    # The default collections:

    def partials
      @collection_objects["GSP::Partial"] || []
    end

    def partial(named:)
      partials.find { |partial| partial.name == named }
    end

    def layouts
      @collection_objects["GSP::Layout"] || []
    end

    def layout(named:)
      layouts.find { |layout| layout.name == named }
    end

    def posts
      @collection_objects["GSP::Post"] || []
    end

    def pages
      @collection_objects["GSP::Page"] || []
    end

    def page(titled:)
      pages.find { |page| page.title == titled }
    end

    def micro_posts
      @collection_objects["GSP::MicroPost"] || []
    end

    def photos
      @collection_objects["GSP::Photo"] || []
    end

    def static_files
      @collection_objects["GSP::StaticFile"] || []
    end


    private

    def method_missing(symbol, *args)
      @metadata&.dig(symbol) || super
    end

    def respond_to_missing?(symbol, include_private = false)
      @metadata&.dig(symbol) || super
    end


  end
end