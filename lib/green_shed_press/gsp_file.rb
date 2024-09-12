module GSP
  class GSPFile
    attr_reader :path, :site

    def initialize(path:, site:)
      @path = File.expand_path(path)
      @site = site
    end

    def basename(suffix: "")
      File.basename(@path, suffix)
    end

    def extname
      File.extname(@path)
    end

    def relative_path
      @path.gsub(site.data_directory, "")
    end

    def content
      @content ||= File.read(@path)
    end

    def content=(new_content)
      @content = new_content
    end

    def save(path:)
      File.open(path, 'w') do |f|
        f.write(content)
      end
    end

  end
end