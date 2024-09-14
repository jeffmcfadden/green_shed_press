module GSP
  class FrontmatterExtractor
    def initialize(content: "")
      @content = content
    end

    # @return [Frontmatter]
    def frontmatter
      @frontmatter ||= extract_frontmatter
    end

    private

    def extract_frontmatter
      frontmatter_yaml = @content.match(/---\n(.*?)\n---\n/m)[1] rescue nil

      frontmatter_data = if frontmatter_yaml.nil?
        {}
      else
        YAML.load(frontmatter_yaml, symbolize_names: true)
      end

      Frontmatter.new(frontmatter_data)
    end


  end
end