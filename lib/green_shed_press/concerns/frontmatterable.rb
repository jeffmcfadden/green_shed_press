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
      self.frontmatter&.dig(symbol) || super
    end

    def respond_to_missing?(symbol, include_private = false)
      self.frontmatter&.dig(symbol) || super
    end

  end
end