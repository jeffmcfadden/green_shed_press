module GSP
  class Builder
    attr_reader :site, :pages, :posts, :micro_posts

    def initialize(data_directory:, output_directory:)
      @data_directory = data_directory
      @output_directory = output_directory
    end

    def load
      @site = Site.load(File.join(@data_directory, 'site.yml'))

      Dir.glob(File.join(@data_directory, 'posts', '*.md')).each do |file|
        post = Post.new(file)
        @posts << post
      end

      Dir.glob(File.join(@data_directory, 'pages', '*.md')).each do |file|
        page = Page.new(file)
        @pages << page
      end

      Dir.glob(File.join(@data_directory, 'micro_posts', '*.md')).each do |file|
        micro_post = MicroPost.new(file)
        @micro_posts << micro_post
      end

      Dir.glob(File.join(@data_directory, "*.md")).each do |file|
        @pages << Page.new(file)
      end

      true
    end

    def build

    end

  end
end