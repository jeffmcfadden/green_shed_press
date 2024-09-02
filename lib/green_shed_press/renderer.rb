module GSP
  class Renderer
    attr_reader :data_directory, :output_directory, :layouts

    def initialize(data_directory:, output_directory:)
      @layouts = {}
      @data_directory = data_directory
      @output_directory = output_directory

      Dir.glob(File.join(@data_directory, "_layouts", "*.erb")).each do |file|
        name = File.basename(file, ".html.erb")
        @layouts[name] = Layout.load(file)
      end

      LOGGER.debug "Layouts: #{@layouts}"
    end

    # Render the contentable with the given context
    # @param [GSP::Contentable] contentable
    # @param [OpenStruct] context the context to render the contentable in
    def render(contentable, context: OpenStruct.new)
      render_context = RenderContext.new(context, base_dir: @data_directory)

      body = contentable.body
      if contentable.filepath.include?(".md")
        body = markdown.render(body)
      end

      new_content = ERB.new(body).result(render_context.instance_eval{ binding })

      LOGGER.debug "contentable.layout: #{contentable.layout}"
      if contentable.layout
        context.content = new_content
        new_content = render(@layouts[contentable.layout], context: context)
      end

      new_content
    end


    private

    # @param [GSP::Contentable] contentable
    # @param [RenderContext] context the context to render the contentable in
    def _render(contentable, context)
      body = contentable.body
      if contentable.filepath.include?(".md")
        body = markdown.render(body)
      end

      ERB.new(body).result(context.instance_eval{ binding })
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

  end
end