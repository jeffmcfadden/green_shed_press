module GSP
  class StaticFile
    include CollectionObject

    # This is a special case where the Site _only_ adds these manually.
    def self.has_collection_object?(file:)
      false
    end

    def generate(output_directory:)
      copy_file_to_destination(output_directory: output_directory)
    end

    def copy_file_to_destination(output_directory:)
      destination_filepath = File.join(output_directory, self.file.relative_path)

      FileUtils.mkdir_p(File.dirname(destination_filepath))
      FileUtils.cp(self.file.path, destination_filepath)
    end

  end
end