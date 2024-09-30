module GSP
  class Document
    attr_reader :filepath
    attr_accessor :content, :body, :rendered_body_no_layout, :frontmatter, :slug

    def initialize(directory:, filepath:, content: nil)
      @directory = directory
      @filepath = filepath

      # Allow content override for "virtual" documents
      if content
        @content = content
      else
        @content = File.open(File.join(@directory, @filepath)).read
      end

      @body = ContentBodyExtractor.new(content: @content).body
      @rendered_body_no_layout = nil
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

    def url
      self.output_filepath
    end

    def layout
      @frontmatter.layout
    end

    def draft?
      @frontmatter.draft.in? [true, "true", 1, "1"]
    end

    def date_from_filename
      # Try to match YYYY-mm-dd-HHMMSS.md (which is a typical micropost filename)
      # Then try to match just YYYY-mm-dd-* (which is a typical post filename)
      # Fallback to underscores just in case

      if s = basename.match(/\d{4}-\d{2}-\d{2}-\d{6}/)
        return Time.strptime(s.to_s, "%Y-%m-%d-%H%M%S")
      end

      if s = basename.match(/\d{4}-\d{2}-\d{2}/)
        return Date.parse(s.to_s)
      end

      if s = basename.match(/\d{4}_\d{2}_\d{2}/)
        return Date.parse(s.to_s.gsub("_", "-"))
      end

      ""
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