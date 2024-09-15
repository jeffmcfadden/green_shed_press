module GSP
  class Photo
    attr_reader :filepath

    def initialize(filepath)
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
      @exif ||= JSON.parse(`exiftool -json -d "%Y-%m-%d %H:%M:%S" #{self.filepath}`).first
    end

  end
end