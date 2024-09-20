module GSP
  class StaticFile
    attr_reader :filepath

    def initialize(directory:, filepath:)
      @directory = directory
      @filepath = filepath
    end

  end
end