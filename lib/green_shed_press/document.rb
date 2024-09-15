module GSP
  class Document
    attr_reader :filepath
    attr_accessor :content, :body, :frontmatter

    def initialize(filepath)
      @filepath = filepath
      @content = File.open(@filepath).read
      @body = ContentBodyExtractor.new(content: @content).body
      @frontmatter = FrontmatterExtractor.new(content: @content).frontmatter
    end

    def markdown?
      File.basename(@filepath).split(".").any?{ |ext| ext == "md" }
    end

    def output_filepath
      filepath
    end

    def layout
      @frontmatter.layout
    end

    def title
      return @title if defined?(@title)

      if self.frontmatter.title
        @title = self.frontmatter.title
      else
        @title = File.basename(self.filepath).split(".").first.titleize
      end
    end

    def method_missing(symbol, *args)
      @frontmatter.try(symbol, *args) || super
    end

  end
end