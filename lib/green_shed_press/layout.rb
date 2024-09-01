module GSP
  class Layout
    attr_reader :name, :filepath, :body, :metadata

    include Frontmatterable

    def self.load(filepath)
      LOGGER.debug "Layout#load #{filepath}"

      data = File.open(filepath).read

      metadata = {}
      frontmatter_yaml = data.match(/---\n(.*?)\n---\n/m)[1] rescue nil
      unless frontmatter_yaml.nil?
        metadata = YAML.load(frontmatter_yaml, symbolize_names: true)
      end

      body = data.match(/---\n.*?\n---\n(.*)/m)[1] rescue nil
      body = data if body.nil?

      name = metadata[:name] || filepath.split('/').last.split('.').first

      new(filepath: filepath, name: name, body: body, metadata: metadata)
    end

    def initialize(**args)
      @filepath = args[:filepath]
      @name = args[:name]
      @body = args[:body]
      @metadata = args[:metadata]
    end


  end
end