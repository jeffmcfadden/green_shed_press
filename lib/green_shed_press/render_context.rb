module GSP
  class RenderContext

    # @param local_assigns [OpenStruct] local variables to make available in the context
    def initialize(local_assigns, base_dir: "./")
      @local_assigns = local_assigns
      @base_dir = base_dir
    end

    def partial(partial_name, locals: {})
      locals.each do |key, value|
        @local_assigns[key] = value
      end

      partial = site.partial(named: partial_name)
      raise "Partial not found: #{partial_name}. Known partials: #{site.partials.map(&:name).join(", ")}" unless partial

      partial_template = partial.content
      ERB.new(partial_template).result(binding)
    end

    def link_to(text, object_or_url)
      if object_or_url.respond_to?(:url)
        url = object_or_url.url
      else
        url = object_or_url.to_s
      end

      "<a href='#{url}'>#{text}</a>"
    end

    private

    def respond_to_missing?(symbol, include_private = false)
      @local_assigns.key?(symbol) || super
    end

    def method_missing(symbol, *args)
      @local_assigns.dig(symbol) || super
    end

  end
end