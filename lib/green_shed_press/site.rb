require 'yaml'

module GSP
  class Site
    include ArbitraryMetadatable

    attr_reader :title, :base_url, :description, :posts, :pages, :micro_posts, :metadata

    # @return [GSP::Site]
    def self.load(filename)
      data = YAML.load_file(filename, symbolize_names: true)

      new(**data)
    end

    def initialize(**args)
      @title = args[:title]
      @base_url = args[:base_url]
      @description = args[:description]
      @posts = args[:posts] || []
      @pages = args[:pages] || []
      @micro_posts = args[:micro_posts] || []
      @metadata = args[:metadata] || {}
    end

  end
end