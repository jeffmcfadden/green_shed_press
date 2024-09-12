module GSP
  class NoopFileProcessor < FileProcessor
    def process
      # No op by default
      nil
    end
  end
end