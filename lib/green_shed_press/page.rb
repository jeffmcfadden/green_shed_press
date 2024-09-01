module GSP
  class Page
    include ArbitraryMetadatable
    include Contentable

    attr_reader :filepath, :title, :body, :slug, :metadata, :created_at, :updated_at


    def self.load(filepath)
      LOGGER.debug "Page#load #{filepath}"

      data = File.open(filepath).read

      metadata = {}
      frontmatter_yaml = data.match(/---\n(.*?)\n---\n/m)[1]
      unless frontmatter_yaml.nil?
        metadata = YAML.load(frontmatter_yaml, symbolize_names: true)
      end

      body = data.match(/---\n.*?\n---\n(.*)/m)[1]
      body = data if body.nil?

      title = metadata[:title] || filepath.split('/').last.split('.').first

      new(filepath: filepath, title: title, body: body, metadata: metadata)
    end

    def initialize(**args)
      @filepath = args[:filepath]
      @title = args[:title]
      @body = args[:body]
      @slug = args[:slug]
      @metadata = args[:metadata]
      @created_at = args[:created_at]
      @updated_at = args[:updated_at]
    end

  end
end