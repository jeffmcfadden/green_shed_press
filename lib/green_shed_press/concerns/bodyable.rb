module GSP
  module Bodyable
    extend ActiveSupport::Concern

    def body
      @body ||= load_body
    end

    private

    def load_body
      ContentBodyExtractor.new(content: self.file.content).body
    end

  end
end