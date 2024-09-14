module GSP
  class Post < Document
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