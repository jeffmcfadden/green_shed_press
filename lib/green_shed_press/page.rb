module GSP
  class Page < Document

    def output_filepath
      slug = self.frontmatter.slug
      if slug
        slug += "index.html" if slug.end_with?("/")
      else
        slug = "/pages/#{self.title.downcase.gsub(" ", "_")}.html"
      end

      slug
    end

    def og_title
      self.title
    end

    def og_image
      ""
    end

  end
end