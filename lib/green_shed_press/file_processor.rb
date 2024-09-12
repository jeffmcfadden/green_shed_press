module GSP
  class FileProcessor

    # @param [GSP::GSPFile] file_wrapper
    def self.for(file_wrapper:)
      case file_wrapper.extname
      when ".md"
        MarkdownProcessor.new(file_wrapper: file_wrapper)
      when ".erb"
        ErbProcessor.new(file_wrapper: file_wrapper)
      else
        FileProcessor.new(file_wrapper: file_wrapper)
      end
    end

    def process
      # No op by default
      nil
    end

  end
end