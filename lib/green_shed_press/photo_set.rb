module GSP
  class PhotoSet < Document
    attr_reader :photos

    def initialize(directory:, filepath:)
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

      dir = File.join(@directory, dirname)

      Dir.glob("#{dir}/*.jpg").each do |photo_path|
        @photos << Photo.new(directory: @directory, filepath: photo_path.gsub(@directory, ""), photo_set: self)
      end
    end

    def dirname
      File.dirname(@filepath)
    end

  end
end