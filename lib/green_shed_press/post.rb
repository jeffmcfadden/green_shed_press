module GSP
  class Post
    include CollectionObject
    include Frontmatterable
    include Bodyable
    include Layoutable

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/posts")
    end

    def generate(output_directory:)
    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      "/posts/#{self.title.downcase.gsub(" ", "_")}.html"
    end


  end
end