module GSP
  class Post
    include Contentable

    def initialize(**args)
      @filepath = args[:filepath]
      @frontmatter = args[:frontmatter]
      @body = args[:body]
      @title = args[:title]
      @slug = args[:slug]
      @created_at = args[:created_at]
      @updated_at = args[:updated_at]

      @frontmatter.layout ||= "post"

    end

    def url
      "#{self.output_filepath}"
    end

    def output_filepath
      "/posts/#{self.title.downcase.gsub(" ", "_")}.html"
    end


  end
end