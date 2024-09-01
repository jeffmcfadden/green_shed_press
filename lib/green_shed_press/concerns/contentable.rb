module GSP
  module Contentable
    extend ActiveSupport::Concern

    include ContentLoadable
    include Frontmatterable

    included do
      attr_reader :filepath, :frontmatter, :title, :body,  :slug, :created_at, :updated_at
    end

    # Returns the layout of the Contentable object, if it exists
    # Expected to be overridden by including class
    # @return [GSP::Layout, nil] the layout of the Contentable object
    def layout
      if @frontmatter
        @frontmatter[:layout]
      else
        nil
      end
    end


  end
end