module GSP
  class MicroPost < Document
    def layout
      super || "micro_post"
    end
  end
end