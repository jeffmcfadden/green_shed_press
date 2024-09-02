module GSP
  class OutputFileMapper
    def initialize(data_directory:, output_directory:)
      @data_directory = data_directory
      @output_directory = output_directory
    end

    def output_filename(filename:)
      ofilename = @output_directory + filename.gsub(@data_directory, "")
                         .gsub('.md', '')
                         .gsub('.erb', '')
                         .gsub('.html', '')

      # .md, .erb, .html all get mapped to .html
      ofilename += ".html" if filename.end_with?(".html", ".md", ".erb")

      ofilename
    end
  end
end