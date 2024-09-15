module GSP
  class PhotoSet < Document
    attr_reader :photos

    def initialize(filepath)
      super
      load_photos
    end

    def output_dirname
      File.join("photos", self.title.downcase.gsub(" ", "_"))
    end

    def output_filepath
      File.join(output_dirname, "index.html")
    end


    private

    def load_photos
      @photos = []
      Dir.glob("#{self.dirname}/*.jpg").each do |photo_path|
        @photos << Photo.new(photo_path)
      end
    end

    def dirname
      File.dirname(@filepath)
    end

  end
end