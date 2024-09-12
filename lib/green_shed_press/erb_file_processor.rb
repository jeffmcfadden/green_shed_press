module GSP
  class ErbFileProcessor < FileProcessor
    def process(file_wrapper:, context:)
      # Render any ERB in the body
      render_context = RenderContext.new(context, base_dir: @data_directory)
      file_wrapper.content = ERB.new(file_wrapper.content).result(render_context.instance_eval{ binding })

      # If this contentable has a layout, render the layout, with the latest output as the `content`
      LOGGER.debug "contentable.layout: #{contentable.layout}"
      if file_wrapper.layout
        context.content = file_wrapper.content

        # Recursive calls for nested layouts
        file_wrapper.content = render(@layouts[file_wrapper.layout], context: context)
      end
    end
  end
end