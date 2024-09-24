module GSP
  class MicroPost < Document
    def layout
      super || "micro_post"
    end

    def title; ""; end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      self.slug || "/micro_posts/#{self.basename(".*")}.html"
    end

    def slug
      self.frontmatter.slug
    end

  end
end