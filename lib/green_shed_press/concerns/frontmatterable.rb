module GSP
  module Frontmatterable
    extend ActiveSupport::Concern

    def frontmatter
      @frontmatter ||= load_frontmatter
    end

    private

    def load_frontmatter
      @frontmatter = FrontmatterExtractor.new(content: self.file.content).frontmatter
    end

    def method_missing(symbol, *args)
      if self.frontmatter&.respond_to?(symbol)
        self.frontmatter.send(symbol, *args)
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      if self.frontmatter&.respond_to?(symbol)
        true
      else
        super
      end
    end

  end
end