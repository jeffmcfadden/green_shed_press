module GSP
  class StaticFile
    include CollectionObject

    # This is a special case where the Site _only_ adds these manually.
    def self.has_collection_object?(file:)
      false
    end

  end
end