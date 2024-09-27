module GSP
  class Book < Document
    extend Forwardable

    def_delegators :frontmatter, :title, :author, :series, :series_position, :pages, :rating, :started_reading_at, :finished_reading_at, :asin

    def output_filepath
      # Replace any non a-z, 0-9, or _ with nothing
      self.frontmatter.slug || "/bookshelf/#{self.title.downcase.gsub(" ", "_").gsub(/[^a-z0-9_]/i, '')}.html"
    end
  end
end