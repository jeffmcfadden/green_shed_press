module GSP
  class Page
    include Contentable

    def initialize(**args)
      @filepath = args[:filepath]
      @title = args[:title]
      @body = args[:body]
      @slug = args[:slug]
      @frontmatter = args[:frontmatter]
      @created_at = args[:created_at]
      @updated_at = args[:updated_at]
    end

  end
end