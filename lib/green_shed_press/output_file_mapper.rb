module GSP
  class OutputFileMapper
    def initialize(data_directory:, output_directory:)
      @data_directory = data_directory
      @output_directory = output_directory
    end

    def output_filename(filename:)
      ofilename = filename.gsub(@data_directory, @output_directory)
                         .gsub('.md', '')
                         .gsub('.erb', '')

      # .md, .erb, .html all get mapped to .html
      ofilename += ".html" if filename.end_with?(".html", ".md", ".erb")

      ofilename
    end
  end
end