require 'yaml'

module GSP
  class Site
    attr_reader :title, :base_url, :description, :metadata, :files
    attr_reader :layouts, :partials, :pages, :posts, :books, :micro_posts, :photo_sets, :static_files

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

      # @type [Array<GSP::Book>]
      @books = []

      @photo_sets = []

      @static_files = []
    end

    def posts_newest_first
      @posts.sort_by(&:created_at).reverse
    end

    def all_items_newest_first
      (@posts + @micro_posts).sort_by(&:created_at).reverse
    end

    def root
      @data_directory
    end

    def relative_path(path)
      path.gsub(self.data_directory, "")
    end

    def load_posts
      LOGGER.debug "Site#load_posts"

      barrier = Async::Barrier.new

      Sync do
        semaphore = Async::Semaphore.new(10, parent: barrier)

        @posts = Dir.glob(File.join(self.data_directory, "_posts", "**", "*.md")).map do |file|
          semaphore.async do
            LOGGER.debug "  #{file}"
            p = Post.new(directory: root, filepath: relative_path(file))
            p.draft? ? nil : p
          end
        end.map(&:wait)
      ensure
        barrier.stop
      end

      @posts.compact!
      @posts
    end

    def load_books
      LOGGER.debug "Site#load_micro_posts"

      @books = Dir.glob(File.join(self.data_directory, "_books", "**", "*.md")).map do |file|
        Book.new(directory: root, filepath: relative_path(file))
      end
    end

    def load_micro_posts
      LOGGER.debug "Site#load_micro_posts"

      Dir.glob(File.join(self.data_directory, "_micro_posts", "**", "*.md")).each do |file|
        @micro_posts << MicroPost.new(directory: root, filepath: relative_path(file))
      end

      @micro_posts
    end

    def load_pages
      LOGGER.debug "Site#load_pages"

      Dir.glob(File.join(self.data_directory, "_pages", "**", "*.md")).each do |file|
        @pages << Page.new(directory: root, filepath: relative_path(file))
      end

      Dir.glob(File.join(self.data_directory, "_pages", "**", "*.erb")).each do |file|
        @pages << Page.new(directory: root, filepath: relative_path(file))
      end

      @pages
    end

    def load_layouts
      LOGGER.debug "Site#load_layouts"

      Dir.glob(File.join(self.data_directory, "_layouts", "**", "*.erb")).each do |file|
        @layouts << Layout.new(directory: root, filepath: relative_path(file))
      end

      @layouts
    end

    def load_partials
      LOGGER.debug "Site#load_partials"

      Dir.glob(File.join(self.data_directory, "_partials", "**", "*.erb")).each do |file|
        @partials << Partial.new(directory: root, filepath: relative_path(file))
      end

      @partials
    end

    def load_photo_sets
      LOGGER.debug "Site#load_photo_sets"

      Dir.glob(File.join(self.data_directory, "_photos", "**", "index.md")).each do |file|
        @photo_sets << PhotoSet.new(directory: root, filepath: relative_path(file))
      end

      @photo_sets
    end

    def load_static_files
      LOGGER.debug "Site#load_static_files"

      Dir.glob(File.join(self.data_directory, '**', '*')).each do |file|
        next if File.directory?(file)
        next if File.basename(file).start_with?(".")
        next if relative_path(file).start_with?("_")
        next if relative_path(file).start_with?("/_")
        next if FILES_TO_SKIP.include?(File.basename(file))

        LOGGER.debug "  #{file}"
        @static_files << GSP::StaticFile.new(directory: root, filepath: relative_path(file))
      end

      @static_files
    end

    def load
      load_layouts
      load_partials
      load_pages
      load_posts
      load_books
      load_micro_posts
      load_photo_sets
      load_static_files
    end

    def generate(output_directory:)
      LOGGER.debug "Site#generate"

      @output_directory = File.expand_path(output_directory)
      build_book_micro_posts
      generate_posts
      generate_micro_posts
      generate_books
      generate_photo_sets
      generate_pages

      copy_static_files
    end

    def generate_pages
      LOGGER.debug "Site#generate_pages"

      @pages.each do
        LOGGER.debug "  #{_1.filepath}"
        if _1.paginated?
          generate_paginated_document(_1)
        else
          generate_document(_1)
        end
      end
    end

    def generate_posts
      LOGGER.debug "Site#generate_posts"

      @posts.each do
        LOGGER.debug "  #{_1.filepath}"
        generate_document(_1)
      end
    end

    # Builds a micro post for each book that has been started
    def build_book_micro_posts
      @books.each do |book|
        next unless book.started_reading_at

        virtual_filepath = "book_micro_posts/#{book.started_reading_at.strftime("%Y-%m-%d")}-#{book.title.downcase.gsub(" ", "_").gsub(/[^a-z0-9_]/i, '')}.html"

        if partial(named: "started_reading_book")
          content = "---\nlayout: micro_post\n---\n<%= partial 'started_reading_book', locals: { book: page.book } %>"
        else
          content = "---\nlayout: micro_post\n---\nStarted reading #{book.title} by #{book.author}"
        end

        mp = MicroPost.new(directory: root, filepath: virtual_filepath, content: content)

        mp.frontmatter.book = book

        @micro_posts << mp
      end
    end

    def generate_micro_posts
      LOGGER.debug "Site#generate_micro_posts"

      @micro_posts.each do
        LOGGER.debug "  #{_1.filepath}"
        generate_document(_1)
      end
    end

    def generate_books
      LOGGER.debug "Site#generate_books"

      @books.each do
        LOGGER.debug "  #{_1.filepath}"
        generate_document(_1)
      end
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

    def generate_paginated_document(document)
      LOGGER.debug "Site#generate_paginated_document: #{document.filepath}"

      items_to_paginate = self.public_send(document.paginate_collection)
      items_to_paginate.each_slice(document.per_page).with_index do |items, index|
        LOGGER.debug "  page #{index + 1}"
        context = OpenStruct.new(
          items: items,
          page_number: index + 1,
          total_pages: (items_to_paginate.length.to_f / document.per_page).ceil,
          total_items: items_to_paginate.length
        )

        this_document = document.dup
        if index == 0
          this_document.slug = document.base_slug
        else
          this_document.slug = document.base_slug + "/page_#{index + 1}.html"
        end

        generate_document(this_document, context: context)
      end
    end

    def generate_photo_set(photo_set)
      LOGGER.debug "Site#generate_document: #{photo_set.filepath}"

      # Generate the index page
      generate_document(photo_set, context: OpenStruct.new(photos: photo_set.photos))

      photo_output_directory = File.join(@output_directory, File.dirname(photo_set.output_filepath))

      # Copy the photos over
      photo_set.photos.each do |photo|
        generate_photo_sizes(photo, output_directory: photo_output_directory)
        photo_page = PhotoPage.new(photo: photo, photo_set: photo_set)
        generate_document(photo_page, context: OpenStruct.new(photo: photo))
      end

      # TODO: Create a photo page for each photo in the set

    end

    def generate_photo_sizes(photo, output_directory:)
      LOGGER.debug "Site#generate_photo: #{photo.filepath}"

      exif_fields_to_keep = ["icc-profile-data", "DateTimeOriginal", "Make", "Model", "LensModel", "FocalLength", "FNumber", "ExposureTime", "ISO", "Flash", "ExposureBiasValue", "ExposureProgram", "MeteringMode", "WhiteBalance", "ExposureMode", "ExposureCompensation", "Software", "Artist", "Copyright"]

      Photo.size_map.each do |size, max_dimension|
        LOGGER.debug "  Rendering photo #{photo.filepath} at size #{size}"
        output_filepath = File.join(output_directory, "#{photo.filename_for_size(size)}")

        if File.exist?(output_filepath)
          LOGGER.debug "  skipping photo #{photo.filepath} at size #{size} because it already exists"
          next
        end

        image = Vips::Image.new_from_file File.join(root, photo.filepath)

        # Remove the EXIF fields we don't want present in the thumbnails, like location data, and the
        # extensive settings that Lightroom, etc add to the EXIF et. al.
        image = image.mutate do |mutable_image|
          mutable_image.get_fields.each do |field|
            mutable_image.remove!(field) unless exif_fields_to_keep.include?(field)
          end

        end

        scale = max_dimension.to_f / [image.width, image.height].max
        scale = 1 if scale > 1

        thumb = image.resize scale
        thumb.write_to_file "#{output_filepath}", Q: 85
      end
    end


    def photos
      @photo_sets.flat_map(&:photos)
    end

    def render(template:, context: nil)
      context ||= OpenStruct.new
      template.body = GSP.render_markdown(template.body) if template.markdown?

      context.site = self unless context.site
      context.page = template unless context.page
      render_context = RenderContext.new(context)

      rendered_content = ERB.new(template.body).result(render_context.instance_eval{ binding })

      if template.respond_to?(:rendered_body_no_layout) && template.rendered_body_no_layout.nil?
        template.rendered_body_no_layout = rendered_content
      end

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

      barrier = Async::Barrier.new

      Sync do
        semaphore = Async::Semaphore.new(10, parent: barrier)

        @static_files.map do |file|
          semaphore.async do
            LOGGER.debug "  #{file.filepath}"
            output_path = file.filepath.sub(self.data_directory, "")
            FileUtils.mkdir_p(File.join(@output_directory, File.dirname(output_path)))
            FileUtils.cp(File.join(self.data_directory, file.filepath), File.join(@output_directory, output_path))
          end
        end.map(&:wait)
      ensure
        barrier.stop
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