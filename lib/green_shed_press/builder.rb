module GSP
  class Builder
    attr_reader :site

    def initialize(data_directory:, output_directory:)
      @data_directory = data_directory
      @output_directory = output_directory

      @output_file_mapper = OutputFileMapper.new(data_directory: @data_directory, output_directory: @output_directory)
    end

    def load
      LOGGER.debug "Builder#load"

      @site = Site.load(File.join(@data_directory, 'site.yml'))

      @files = []
      Dir.glob(File.join(@data_directory, '**', '*')).each do |file|
        @files << GSPFile.new(path: file)
      end

      true
    end
    def build
      @files.each(&:process)
    end

    def old_load
      LOGGER.debug "Builder#old_load"

      @site = Site.load(File.join(@data_directory, 'site.yml'))

      Dir.glob(File.join(@data_directory, 'posts', '*.md')).each do |file|
        post = Post.load(file)
        @site.posts << post
      end

      Dir.glob(File.join(@data_directory, 'pages', '*.md')).each do |file|
        page = Page.load(file)
        @site.pages << page
      end

      Dir.glob(File.join(@data_directory, 'pages', '*.erb')).each do |file|
        page = Page.load(file)
        @site.pages << page
      end

      Dir.glob(File.join(@data_directory, 'micro_posts', '*.md')).each do |file|
        micro_post = MicroPost.load(file)
        @site.micro_posts << micro_post
      end

      Dir.glob(File.join(@data_directory, "*.md")).each do |file|
        @site.pages << Page.load(file)
      end

      Dir.glob(File.join(@data_directory, "*.erb")).each do |file|
        @site.pages << Page.load(file)
      end

      Dir.glob(File.join(@data_directory, 'photos', '**/*')).each do |file|
        next unless File.basename(file).downcase.end_with?('.jpg', '.jpeg')
        @site.photos << Photo.load(file)
      end

      true
    end

    def old_build
      LOGGER.debug "Builder#old_build"

      build_pages
      build_photos
      copy_assets

      true
    end

    def build_pages
      [@site.pages, @site.posts].flatten.each do |contentable|
        LOGGER.debug"  Builder#build rendering page #{contentable.filepath}"
        output = renderer.render(contentable, context: OpenStruct.new(site: @site, page: contentable ))

        # Get the output filename
        output_filename = @output_file_mapper.output_filename(filename: contentable.output_filepath)

        # Make sure the Dir exists
        FileUtils.mkdir_p(File.dirname(output_filename))

        # Write the file contents
        LOGGER.debug "Writing output file #{output_filename}"
        File.open(output_filename, 'w') do |f|
          f.write(output)
        end
      end
    end

    def build_photos
      LOGGER.debug "Builder#build_photos"

      @site.photos.each do |photo|
        LOGGER.debug "  Builder#build rendering photo #{photo.filepath}"
        output_filename = @output_file_mapper.output_filename(filename: photo.output_filepath)

        basename = File.basename(output_filename, '.*')

        output_directory = File.dirname(output_filename)
        FileUtils.mkdir_p(output_directory)

        exif_fields_to_keep = ["icc-profile-data", "DateTimeOriginal", "Make", "Model", "LensModel", "FocalLength", "FNumber", "ExposureTime", "ISO", "Flash", "ExposureBiasValue", "ExposureProgram", "MeteringMode", "WhiteBalance", "ExposureMode", "ExposureCompensation", "Software", "Artist", "Copyright"]

        [2048, 1024, 800, 600, 400, 200].each do |size|
          LOGGER.debug "  Builder#build rendering photo #{photo.filepath} at size #{size}"
          output_filepath = File.join(output_directory, "#{basename}_#{size}.jpg")

          if File.exist?(output_filepath)
            LOGGER.debug "  Builder#build skipping photo #{photo.filepath} at size #{size} because it already exists"
            next
          end

          image = Vips::Image.new_from_file photo.filepath

          # Remove the EXIF fields we don't want present in the thumbnails, like location data, and the
          # extensive settings that Lightroom, etc add to the EXIF et. al.
          image = image.mutate do |mutable_image|
            mutable_image.get_fields.each do |field|
              mutable_image.remove!(field) unless exif_fields_to_keep.include?(field)
            end

          end

          scale = size.to_f / [image.width, image.height].max

          thumb = image.resize scale
          thumb.write_to_file "#{output_filepath}", Q: 85
        end

        # Copy the original over, too.
        FileUtils.cp(photo.filepath, output_filename)
      end
    end

    def copy_assets
      LOGGER.debug "Copying assets to output"
      FileUtils.cp_r(File.join(@data_directory, 'assets'), @output_directory)
    end

    private

    def renderer
      @renderer ||= Renderer.new(data_directory: @data_directory, output_directory: @output_directory)
    end

  end
end