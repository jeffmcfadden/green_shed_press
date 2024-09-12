module GSP
  class Layout
    include CollectionObject
    include Frontmatterable
    include Bodyable

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/_layouts")
    end

  end
end