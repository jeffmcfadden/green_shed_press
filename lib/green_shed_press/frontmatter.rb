module GSP
  class Frontmatter < OpenStruct

    def to_s
      self.to_h.to_s
    end

    def inspect
      self.to_h.inspect
    end

  end
end