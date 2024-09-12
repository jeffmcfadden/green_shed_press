module GSP
  class Page
    include CollectionObject
    include Frontmatterable
    include Bodyable
    include Layoutable

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/pages")
    end

    def title
      return @title if defined?(@title)

      if self.frontmatter.title
        @title = self.frontmatter.title
      else
        @title = self.file.basename.split(".").first.titleize
      end
    end

    def og_title
      @title
    end

    def og_image
      ""
    end

  end
end