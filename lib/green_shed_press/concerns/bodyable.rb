module GSP
  module Bodyable
    extend ActiveSupport::Concern

    def body
      @body ||= load_body
    end

    def markdown?
      self.file.basename.to_s.end_with?(".md") || self.file.basename.to_s.end_with?(".md.erb")
    end

    def erb?
      self.file.basename.to_s.end_with?(".erb")
    end

    private

    def load_body
      ContentBodyExtractor.new(content: self.file.content).body
    end

  end
end