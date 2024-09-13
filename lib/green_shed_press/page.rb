module GSP
  class Page
    include CollectionObject
    include Frontmatterable
    include Bodyable
    include Layoutable

    def self.has_collection_object?(file:)
      file.relative_path.start_with?("/pages")
    end

    def generate(output_directory:)
      FileUtils.mkdir_p(File.join(output_directory, File.dirname(self.output_filepath)))
      File.open(File.join(output_directory, self.output_filepath), "w") do |file|
        file.write(self.body)
      end
    end

    def title
      return @title if defined?(@title)

      if self.frontmatter.title
        @title = self.frontmatter.title
      else
        @title = self.file.basename.split(".").first.titleize
      end
    end

    def output_filepath
      slug = self.frontmatter.slug
      if slug
        slug += "index.html" if slug.end_with?("/")
      else
        slug = "/pages/#{self.title.downcase.gsub(" ", "_")}.html"
      end

      slug
    end

    def og_title
      @title
    end

    def og_image
      ""
    end

  end
end