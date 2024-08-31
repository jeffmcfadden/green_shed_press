module GSP
  class Page
    attr_reader :filename, :title, :body, :slug, :metadata, :created_at, :updated_at

    def self.load(filename)
      data = File.open(filename).read

      metadata = {}
      frontmatter_yaml = data.match(/(.*?)\n---\n/m)[1]
      unless frontmatter_yaml.nil?
        metadata = YAML.load(frontmatter_yaml, symbolize_names: true)
      end

      body = data.match(/---\n(.*)/m)[1]
      body = data if body.nil?

      title = metadata[:title] || filename.split('/').last.split('.').first

      new(filename: filename, title: title, body: body, metadata: metadata)
    end

    def initialize(**args)
      @filename = args[:filename]
      @title = args[:title]
      @body = args[:body]
      @slug = args[:slug]
      @metadata = args[:metadata]
      @created_at = args[:created_at]
      @updated_at = args[:updated_at]
    end

    private
    # Allow metadata fields to be accessed like method calls with dot syntax
    def method_missing(symbol, *args)
      if @metadata.key?(symbol)
        @metadata[symbol]
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      @metadata.key?(symbol) || super
    end


  end
end