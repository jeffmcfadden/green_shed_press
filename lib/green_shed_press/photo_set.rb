module GSP
  class PhotoSet < Document
    attr_reader :photos

    def initialize(filepath)
      super

      load_photos
    end

    private

    def load_photos
      @photos = []
      Dir.glob("#{self.filepath.dirname}/*.jpg").each do |photo_path|
        @photos << Photo.new(photo_path)
      end
    end
  end
end