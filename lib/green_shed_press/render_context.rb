module GSP
  class RenderContext

    # @param local_assigns [OpenStruct] local variables to make available in the context
    def initialize(local_assigns, base_dir: "./")
      @local_assigns = local_assigns
      @base_dir = base_dir
    end

    def partial(partial_name)
      partial_name = partial_name.to_s
      partial_path = File.join(@base_dir, "_partials", "#{partial_name}.html.erb")
      partial_template = File.read(partial_path)
      ERB.new(partial_template).result(binding)
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