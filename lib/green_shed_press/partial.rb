module GSP
  class Partial
    include CollectionObject
    include Frontmatterable
    include Bodyable

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/_partials")
    end

  end
end