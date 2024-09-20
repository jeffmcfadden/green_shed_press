module GSP
  class Post < Document

    def draft?
      self.frontmatter.draft.in? [true, "true", 1, "1"]
    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      self.slug || "/posts/#{self.title.downcase.gsub(" ", "_")}.html"
    end

    def slug
      self.frontmatter.slug
    end


  end
end