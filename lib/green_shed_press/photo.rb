module GSP
  class Photo
    attr_reader :filepath

    def self.load(filepath)
      new(filepath: filepath)
    end

    def initialize(filepath:)
      @filepath = filepath
    end

    def generate(output_directory:)
    end

    def output_filepath
      @filepath
    end

    def url(size: :large)
      output_filepath = self.output_filepath.gsub("./data", "")

      dir      = File.dirname(output_filepath)
      filename = File.basename(output_filepath, ".*")

      size = 600

      File.join(dir, "#{filename}_#{size}.jpg")
    end

    def alt
      ""
    end

    def caption
      ""
    end

    def exif
      @exif ||= JSON.parse(`exiftool -json -d "%Y-%m-%d %H:%M:%S" #{filepath}`).first
    end

  end
end