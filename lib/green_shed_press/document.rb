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

    def basename(*args)
      File.basename(@filepath, *args)
    end

    def output_filepath
      filepath
    end

    def layout
      @frontmatter.layout
    end

    def draft?
      @frontmatter.draft.in? [true, "true", 1, "1"]
    end

    def date_from_filename
      basename.match(/\d{4}-\d{2}-\d{2}/).to_s
    end

    def created_at
      date = frontmatter.date || frontmatter.created_at || date_from_filename

      if date.is_a? String
        Date.parse(date)
      else
        date
      end
    end

    def title
      return @title if defined?(@title)

      if self.frontmatter.title
        @title = self.frontmatter.title.strip
      else
        @title = File.basename(self.filepath).split(".").first.strip.titleize
      end
    end

    def untitled?
      self.title.strip.empty?
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