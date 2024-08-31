module GSP
  module ArbitraryMetadatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    private

    def method_missing(symbol, *args)
      super unless @metadata

      if @metadata.key?(symbol)
        @metadata[symbol]
      else
        super
      end
    end

    def respond_to_missing?(symbol, include_private = false)
      super unless @metadata

      @metadata.key?(symbol) || super
    end

    module ClassMethods

    end

  end
end