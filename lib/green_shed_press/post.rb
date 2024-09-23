module GSP
  class Post < Document

    def created_at
      date = frontmatter.date || frontmatter.created_at || date_from_filename

      if date.is_a? String
        Date.parse(date)
      else
        date
      end
    end

    def layout
      super || "post"
    end

    def date_from_filename
      filename.match(/\d{4}-\d{2}-\d{2}/).to_s
    end

    def draft?
      self.frontmatter.draft.in? [true, "true", 1, "1"]
    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      # Replace any non a-z, 0-9, or _ with nothing
      self.slug || "/posts/#{self.title.downcase.gsub(" ", "_").gsub(/[^a-z0-9_]/i, '')}.html"
    end

    def slug
      self.frontmatter.slug
    end


  end
end