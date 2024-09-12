module GSP
  class Renderer
    def initialize(site:)
      @site = site
    end

    # Render the contentable with the given context
    # @param [GSP::Bodyable] bodyable object
    # @param [OpenStruct] context (local assigns, essentially) for the render
    def render(bodyable, context: OpenStruct.new)
      body = bodyable.body
      if bodyable.markdown?
        body = markdown.render(body)
      end

      # Render any ERB in the body
      context.site = @site
      render_context = RenderContext.new(context)

      if bodyable.erb?
        new_content = ERB.new(body).result(render_context.instance_eval{ binding })
      else
        new_content = body
      end

      # If this contentable has a layout, render the layout, with the latest output as the `content`
      LOGGER.debug "bodyable.layout: #{bodyable.layout}"
      if bodyable.try(:layout)
        context.content = new_content

        # Recursive calls for nested layouts
        new_content = render(@site.layout(named: bodyable.layout), context: context)
      end

      new_content
    end


    private

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    end

  end
end