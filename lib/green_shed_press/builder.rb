module GSP
  class Builder
    attr_reader :site, :pages, :posts, :micro_posts

    def initialize(data_directory:, output_directory:)
      @data_directory = data_directory
      @output_directory = output_directory

      @pages = []
      @posts = []
      @micro_posts = []
      @layouts = []

      @output_file_mapper = OutputFileMapper.new(data_directory: @data_directory, output_directory: @output_directory)
    end

    def load
      LOGGER.debug "Builder#load"

      @site = Site.load(File.join(@data_directory, 'site.yml'))

      Dir.glob(File.join(@data_directory, 'posts', '*.md')).each do |file|
        post = Post.load(file)
        @posts << post
      end

      Dir.glob(File.join(@data_directory, 'pages', '*.md')).each do |file|
        page = Page.load(file)
        @pages << page
      end

      Dir.glob(File.join(@data_directory, 'micro_posts', '*.md')).each do |file|
        micro_post = MicroPost.load(file)
        @micro_posts << micro_post
      end

      Dir.glob(File.join(@data_directory, "*.md")).each do |file|
        @pages << Page.load(file)
      end

      Dir.glob(File.join(@data_directory, "*.erb")).each do |file|
        @pages << Page.load(file)
      end

      true
    end

    def build
      LOGGER.debug "Builder#build"
      [@pages, @posts].flatten.each do |contentable|
        LOGGER.debug"  Builder#build rendering page #{contentable.filepath}"
        output = renderer.render(contentable, context: OpenStruct.new(site: @site, page: contentable ))

        # Get the output filename
        output_filename = @output_file_mapper.output_filename(filename: contentable.filepath)

        # Make sure the Dir exists
        FileUtils.mkdir_p(File.dirname(output_filename))

        # Write the file contents
        LOGGER.debug "Writing output file #{output_filename}"
        File.open(output_filename, 'w') do |f|
          f.write(output)
        end
      end
    end

    private

    def renderer
      @renderer ||= Renderer.new(data_directory: @data_directory, output_directory: @output_directory)
    end

  end
end