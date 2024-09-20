module GSP
  class Photo
    attr_reader :filepath

    def initialize(directory:, filepath:)
      @directory = directory
      @filepath = filepath
    end

    def filename_for_size(size)
      "#{File.basename(self.filepath, ".*")}_#{size}.jpg"
    end

    def basename
      File.basename(self.filepath, ".*")
    end

    def alt
      ""
    end

    def caption
      ""
    end

    def exif
      @exif ||= JSON.parse(`exiftool -json -d "%Y-%m-%d %H:%M:%S" #{@directory}#{@filepath}`).first
    end

  end
end