module GSP
  class Book < Document
    def title; frontmatter.title; end
    def author; frontmatter.author; end
    def series; frontmatter.series; end
    def series_position; frontmatter.series_position; end
    def pages; frontmatter.pages; end
    def rating; frontmatter.rating; end

    def started_reading_at; frontmatter.started_reading_at; end
    def finished_reading_at; frontmatter.finished_reading_at; end
    def asin; frontmatter.asin; end


    def layout; "book"; end

    def output_filepath
      # Replace any non a-z, 0-9, or _ with nothing
      self.frontmatter.slug || "/bookshelf/#{self.title.downcase.gsub(" ", "_").gsub(/[^a-z0-9_]/i, '')}.html"
    end
  end
end