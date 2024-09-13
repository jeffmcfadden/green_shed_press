module GSP
  class Photo
    include CollectionObject

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/photos")
    end

    def generate(output_directory:)
      copy_image_file(output_directory: output_directory)

      make_image_landing_page(output_directory: output_directory)

    end

    def copy_image_file(output_directory:)
      FileUtils.mkdir_p(File.join(output_directory, File.dirname(self.output_filepath)))
      FileUtils.copy_file(self.file.path, File.join(output_directory, self.output_filepath))
    end

    def make_image_landing_page(output_directory:)
      landing_page_filepath = self.output_filepath + ".html"

      File.open(File.join(output_directory, landing_page_filepath), "w") do |f|
        f.write <<-HTML
<!DOCTYPE html>
<html><body>
<img src="#{self.url}" alt="#{self.alt}" />
<p>#{self.caption}</p>
<p>exif to come</p>
</body></html>
        HTML
      end
    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      self.file.relative_path
    end

    def alt
      ""
    end

    def caption
      ""
    end

    def exif
      @exif ||= JSON.parse(`exiftool -json -d "%Y-%m-%d %H:%M:%S" #{self.file.path}`).first
    end

  end
end