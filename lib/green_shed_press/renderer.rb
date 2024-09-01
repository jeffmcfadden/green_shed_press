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
      output = _render(contentable, context)

      if contentable.layout
        LOGGER.debug "Layout: #{contentable.layout}"
        context.content = output
        output = _render(@layouts[contentable.layout], context)
      end

      output
    end


    private

    # @param [GSP::Contentable] contentable
    # @param [OpenStruct] context the context to render the contentable in
    def _render(contentable, context)
      ERB.new(contentable.body).result(context.instance_eval{ binding })
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

  end
end