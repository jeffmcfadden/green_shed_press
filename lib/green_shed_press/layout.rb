module GSP
  class Layout
    include CollectionObject
    include Frontmatterable
    include Bodyable
    include Layoutable

    def name
      file.basename.split(".").first
    end

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/_layouts")
    end

    def generate(output_directory:)
    end

    def renderable?
      false
    end


  end
end