module GSP

  def self.register_collection_object_type(klass)
    collection_object_types << klass
  end

  def self.collection_object_types
    @collection_object_types ||= []
  end

  # Support for collection objects, which create more structured data from a give file
  module CollectionObject
    extend ActiveSupport::Concern

    included do
      GSP.register_collection_object_type(self)
    end

    class_methods do
      # If this object can generate a collection object for the given file, then return true
      def has_collection_object?(file:)
        false
      end

      # The collection object to be generated from the given file
      def collection_objects(file:)
        Array(new(file: file))
      end
    end

    # @param [GSPFile] file
    def initialize(file:)
      @file = file
    end

    # @return [GSPFile] file wrapper for this object
    def file
      @file
    end

    def generate(output_directory:)
      raise NotImplementedError, "You must implement generate in your collection object. (#{self.class})"
    end

  end
end