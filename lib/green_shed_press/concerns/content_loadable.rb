module GSP

  # Loads a Contentable from a given filepath, including setting the
  # frontmatter for the contentable. Used by Contentable classes.
  module ContentLoadable
    extend ActiveSupport::Concern

    class_methods do


      def load(filepath)
        data = File.open(filepath).read

        frontmatter = FrontmatterExtractor.new(content: data).frontmatter
        body = ContentBodyExtractor.new(content: data).body

        title = frontmatter.dig(:title)
        if title.nil?
          title = File.basename(filepath, ".*").gsub("_", " ")
        end

        new(filepath: filepath, frontmatter: frontmatter, title: title, body: body)
      end
    end

  end
end
