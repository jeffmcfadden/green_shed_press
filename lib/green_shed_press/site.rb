require 'yaml'

module GSP
  class Site
    attr_reader :title, :base_url, :description, :metadata, :files
    attr_reader :layouts, :partials, :pages, :posts, :micro_posts, :photo_sets, :static_files

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

      @layouts = []
      @partials = []

      @posts = []
      @micro_posts = []
      @pages = []

      @photo_sets = []

      @static_files = []
    end

    def load_posts
      LOGGER.debug "Site#load_posts"

      Dir.glob(File.join(self.data_directory, "_posts", "**", "*.md")).each do |file|
        @posts << Post.new(file)
      end

      @posts
    end

    def load_micro_posts
      LOGGER.debug "Site#load_micro_posts"

      Dir.glob(File.join(self.data_directory, "_micro_posts", "**", "*.md")).each do |file|
        @micro_posts << MicroPost.new(file)
      end

      @micro_posts
    end

    def load_pages
      LOGGER.debug "Site#load_pages"

      Dir.glob(File.join(self.data_directory, "_pages", "**", "*.md")).each do |file|
        @pages << Page.new(file)
      end

      @pages
    end

    def load_layouts
      LOGGER.debug "Site#load_layouts"

      Dir.glob(File.join(self.data_directory, "_layouts", "**", "*.erb")).each do |file|
        @layouts << Layout.new(file)
      end

      @layouts
    end

    def load_partials
      LOGGER.debug "Site#load_partials"

      Dir.glob(File.join(self.data_directory, "_partials", "**", "*.erb")).each do |file|
        @partials << Partial.new(file)
      end

      @partials
    end

    def load_photo_sets
      LOGGER.debug "Site#load_photo_sets"

      Dir.glob(File.join(self.data_directory, "_photos", "**", "index.md")).each do |file|
        @photo_sets << PhotoSet.new(file)
      end

      @photo_sets
    end

    def load_static_files
      LOGGER.debug "Site#load_static_files"

      Dir.glob(File.join(self.data_directory, '**', '*')).each do |file|
        relative_path = file.sub(self.data_directory, "")

        next if File.directory?(file)
        next if File.basename(file).start_with?(".")
        next if relative_path.start_with?("_")
        next if relative_path.start_with?("/_")
        next if FILES_TO_SKIP.include?(File.basename(file))

        LOGGER.debug "  #{file}"
        @static_files << GSP::StaticFile.new(file)
      end

      @static_files
    end

    def load
      load_layouts
      load_partials
      load_pages
      load_posts
      load_micro_posts
      load_photo_sets
      load_static_files
    end

    def generate(output_directory:)
      LOGGER.debug "Site#generate"

      @output_directory = File.expand_path(output_directory)
      generate_pages
      generate_posts
      generate_photo_sets

      copy_static_files
    end

    def generate_pages
      LOGGER.debug "Site#generate_pages"

      @pages.each{ generate_document(_1) }
    end

    def generate_posts
      LOGGER.debug "Site#generate_posts"

      @posts.each{ generate_document(_1) }
    end

    def generate_photo_sets
      LOGGER.debug "Site#generate_photo_sets"

      @photo_sets.each{ generate_photo_set(_1) }
    end

    def generate_document(document, context: nil)
      LOGGER.debug "Site#generate_document: #{document.filepath}"

      content = render(template: document, context: context)

      FileUtils.mkdir_p(File.join(@output_directory, File.dirname(document.output_filepath)))
      File.open(File.join(@output_directory, document.output_filepath), "w") do |f|
        f.write content
      end
    end

    def generate_photo_set(photo_set)
      LOGGER.debug "Site#generate_document: #{photo_set.filepath}"

      # Generate the index page
      generate_document(photo_set, context: OpenStruct.new(photos: photo_set.photos))

      photo_output_directory = File.join(@output_directory, File.dirname(photo_set.output_filepath))

      # Copy the photos over
      photo_set.photos.each do |photo|
        LOGGER.debug "  Copying photo file #{photo.filepath}"
        LOGGER.debug "  to #{photo_output_directory}"
        output_path = File.join(photo_output_directory, File.basename(photo.filepath))
        FileUtils.cp(photo.filepath, output_path)
      end
    end

    def render(template:, context: nil)
      context ||= OpenStruct.new
      template.body = GSP.markdown.render(template.body) if template.markdown?

      context.site = self unless context.site
      context.page = template unless context.page
      render_context = RenderContext.new(context)

      rendered_content = ERB.new(template.body).result(render_context.instance_eval{ binding })

      if template.layout
        layout = layout(named: template.layout)
        unless layout
          raise "Layout not found: #{template.layout}. Known layouts: #{layouts.map(&:name).join(", ")}"
        end

        context.content = rendered_content

        # Recursive calls for nested layouts
        rendered_content = render(template: layout, context: context)
      end

      rendered_content
    end

    def copy_static_files
      LOGGER.debug "Site#copy_static_files"

      @static_files.each do |file|
        LOGGER.debug "  #{file.filepath}"
        output_path = file.filepath.sub(self.data_directory, "")
        FileUtils.mkdir_p(File.join(@output_directory, File.dirname(output_path)))
        FileUtils.cp(file.filepath, File.join(@output_directory, output_path))
      end
    end


    # Finders:

    # @return [GSP::Partial, nil]
    def partial(named:)
      @partials.find { _1.name == named }
    end

    # @return [GSP::Layout, nil]
    def layout(named:)
      @layouts.find {_1.name == named }
    end

    # @return [GSP::Page, nil]
    def page(titled:)
      @pages.find { _1.title == titled }
    end

    def photo_set(titled:)
      @photo_sets.find { _1.title == titled }
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