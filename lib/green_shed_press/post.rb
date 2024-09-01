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
    end

  end
end