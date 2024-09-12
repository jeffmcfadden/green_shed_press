module GSP
  module Layoutable
    extend ActiveSupport::Concern

    def layout
      self.frontmatter&.layout || nil
    end

  end
end