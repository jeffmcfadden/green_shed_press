module GSP
  class StaticFile
    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
    end

  end
end