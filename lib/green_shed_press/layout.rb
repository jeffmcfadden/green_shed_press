module GSP
  class Layout
    attr_reader :name, :filepath, :body

    include Contentable


    def initialize(**args)
      @filepath = args[:filepath]
      @name = args[:name]
      @body = args[:body]

      @frontmatter = args[:frontmatter]
    end


  end
end