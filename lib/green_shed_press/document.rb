module GSP
  class Document
    attr_reader :filepath
    attr_accessor :content, :body, :frontmatter, :slug

    def initialize(directory:, filepath:)
      @directory = directory
      @filepath = filepath
      @content = File.open(File.join(@directory, @filepath)).read
      @body = ContentBodyExtractor.new(content: @content).body
      @frontmatter = FrontmatterExtractor.new(content: @content).frontmatter
    end

    def paginated?
      self.frontmatter.paginate_collection
    end

    def markdown?
      basename.split(".").any?{ |ext| ext == "md" }
    end

    def basename
      File.basename(@filepath)
    end

    def output_filepath
      filepath
    end

    def layout
      @frontmatter.layout
    end

    def title
      return @title if defined?(@title)

      if self.frontmatter.title && !self.frontmatter.title.empty?
        @title = self.frontmatter.title
      else
        @title = File.basename(self.filepath).split(".").first.titleize
      end
    end

    def slug
      @slug ||= self.frontmatter.slug || self.title.downcase.gsub(" ", "-")
    end

    def tags
      @frontmatter.tags&.split(",")&.map(&:strip) || []
    end

    def method_missing(symbol, *args)
      @frontmatter.try(symbol, *args) || super
    end

  end
end