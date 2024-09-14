module GSP
  class Layout < Document

    def name
      File.basename(@filepath).split(".").first
    end

    def markdown?
      false
    end

    def generate(output_directory:)
    end

    def renderable?
      false
    end


  end
end