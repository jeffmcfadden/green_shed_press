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
    end

    def load
      LOGGER.debug "Builder#load"

      @site = Site.load(File.join(@data_directory, 'site.yml'))

      Dir.glob(File.join(@data_directory, 'posts', '*.md')).each do |file|
        post = Post.new(file)
        @posts << post
      end

      Dir.glob(File.join(@data_directory, 'pages', '*.md')).each do |file|
        page = Page.load(file)
        @pages << page
      end

      Dir.glob(File.join(@data_directory, 'micro_posts', '*.md')).each do |file|
        micro_post = MicroPost.new(file)
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
      @pages.each do |page|

        LOGGER.debug "Page body:\n\n#{page.body}\n\n"

        output = renderer.render(page, context: OpenStruct.new(site: @site, page: page ))

        LOGGER.debug "File output:\n\n#{output}\n\n"

        # puts output_file_path(page)
      end
    end

    private

    def output_file_path(page)
      File.join(@output_directory, page.filepath.gsub(@data_directory, '').gsub('.md', '.html').gsub('.erb', '.html'))
    end

    def renderer
      @renderer ||= Renderer.new(data_directory: @data_directory, output_directory: @output_directory)
    end

  end
end