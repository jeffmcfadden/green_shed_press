module GSP
  module Contentable
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Returns the body of the Contentable object
    # @note: Expected to be overridden by including class
    # @return [String] the body of the Contentable object
    def body
      ""
    end

    # Returns the layout of the Contentable object, if it exists
    # Expected to be overridden by including class
    # @return [GSP::Layout, nil] the layout of the Contentable object
    def layout
      if @metadata
        @metadata[:layout]
      else
        nil
      end
    end

    private

    module ClassMethods

    end

  end
end