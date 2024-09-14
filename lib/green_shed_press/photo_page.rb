module GSP
  class PhotoPage
    include CollectionObject
    include Frontmatterable
    include Bodyable
    include Layoutable

    attr_accessor :photo

    def self.has_collection_object?(file:)
      false # Always returned from a Photo itself.
    end

    def initialize(file:, photo:)
      @file = file
      @photo = photo
      @body = ""
    end

    def layout
      "photo"
    end

    def markdown?
      false
    end

    def erb?
      true
    end

    def generate(output_directory:)
      FileUtils.mkdir_p(File.join(output_directory, File.dirname(self.output_filepath)))
      File.open(File.join(output_directory, self.output_filepath), "w") do |file|
        file.write(self.body)
      end
    end

    def title
      ""
    end

    def output_filepath
      self.photo.output_filepath + ".html"
    end

    def url
      "#{self.output_filepath}"
    end

    def og_title
      ""
    end

    def og_image
      ""
    end

  end
end