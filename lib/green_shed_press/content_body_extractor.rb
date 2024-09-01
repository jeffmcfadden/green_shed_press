module GSP
  class ContentBodyExtractor
    def initialize(content:)
      @content = content
    end

    # @return [String] the body of the content
    def body
      body = @content.match(/---\n.*?\n---\n(.*)/m)[1] rescue nil
      body = @content if body.nil?

      body
    end

  end
end