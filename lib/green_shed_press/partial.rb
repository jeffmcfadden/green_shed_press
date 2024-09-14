module GSP
  class Partial < Document
    def name
      File.basename(@filepath).split(".").first
    end

    def markdown?
      false
    end

  end
end