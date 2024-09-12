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
      FileUtils.mkdir_p(File.join(output_directory, "/posts"))
      File.open(File.join(output_directory, self.output_filepath), "w") do |file|
        file.write(self.body)
      end
    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      "/posts/#{self.title.downcase.gsub(" ", "_")}.html"
    end


  end
end