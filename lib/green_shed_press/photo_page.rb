module GSP
  class PhotoPage
    include CollectionObject
    include Bodyable
    include Layoutable

    attr_accessor :photo, :photo_set

    def initialize(photo:, photo_set:)
      @photo = photo
      @photo_set = photo_set
      @body = ""
    end

    def filepath
      output_filepath
    end

    def layout
      "photo"
    end

    def markdown?
      false
    end

    def erb?
      true
    end

    def title
      ""
    end

    def output_filepath
      File.join( self.photo_set.output_dirname, self.photo.basename + ".html" )
    end

    def url
      "#{self.output_filepath}"
    end

    def og_title
      ""
    end

    def og_image
      ""
    end

  end
end