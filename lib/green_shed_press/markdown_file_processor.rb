module GSP
  class MarkdownFileProcessor < FileProcessor

    def process(file_wrapper:, context: nil)
      file_wrapper.content = markdown.render(file_wrapper.content)
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

  end
end