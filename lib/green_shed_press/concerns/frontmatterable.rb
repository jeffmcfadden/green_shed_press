module GSP
  module Frontmatterable
    extend ActiveSupport::Concern

    private

    def method_missing(symbol, *args)
      @frontmatter&.dig(symbol) || super
    end

    def respond_to_missing?(symbol, include_private = false)
      @frontmatter&.dig(symbol) || super
    end

  end
end