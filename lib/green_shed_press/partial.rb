module GSP
  class Partial
    include CollectionObject
    include Frontmatterable
    include Bodyable
    include Layoutable

    def name
      file.basename.split(".").first
    end

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/_partials")
    end

  end
end