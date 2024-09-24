module GSP
  class Post < Document

    def layout
      super || "post"
    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      # Replace any non a-z, 0-9, or _ with nothing
      self.slug || "/posts/#{self.title.downcase.gsub(" ", "_").gsub(/[^a-z0-9_]/i, '')}.html"
    end

    def slug
      self.frontmatter.slug
    end


  end
end