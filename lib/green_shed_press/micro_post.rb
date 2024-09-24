module GSP
  class MicroPost < Document
    def layout
      super || "micro_post"
    end

    def title; ""; end

  end
end