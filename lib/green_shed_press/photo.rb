module GSP
  class Photo
    attr_reader :filepath

    def initialize(directory:, filepath:, photo_set:)
      @directory = directory
      @filepath = filepath
      @photo_set = photo_set
    end

    def filename_for_size(size)
      "#{File.basename(self.filepath, ".*")}_#{size}.jpg"
    end

    def basename
      File.basename(self.filepath, ".*")
    end

    def page_url
      File.join( "/", @photo_set.output_dirname, "#{basename}.html" )
    end

    def url_for_size(size)
      File.join( "/", @photo_set.output_dirname, filename_for_size(size) )
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