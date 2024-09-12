module GSP
  class Page
    include CollectionObject
    include Frontmatterable
    include Bodyable

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/pages")
    end

    def og_title
      @title
    end

    def og_image
      ""
    end

  end
end