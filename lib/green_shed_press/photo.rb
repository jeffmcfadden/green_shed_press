module GSP
  class Photo
    attr_reader :filepath, :photo_set

    def self.size_map
      { "full" => 9999999,
        "2048" => 2048,
        "1024" => 1024,
        "800" => 800,
        "600" => 600,
        "400" => 400,
        "200" => 200 }
    end

    def initialize(directory:, filepath:, photo_set:)
      @directory = directory
      @filepath = filepath
      @photo_set = photo_set
    end

    def filename_for_size(size)
      "#{File.basename(self.filepath, ".*")}_#{size}.jpg"
    end

    def basename
      File.basename(self.filepath, ".*")
    end

    def page_url
      File.join( "/", @photo_set.output_dirname, "#{basename}.html" )
    end

    def url_for_size(size)
      File.join( "/", @photo_set.output_dirname, filename_for_size(size) )
    end

    def alt
      ""
    end

    def caption
      ""
    end

    # Sample exif data:
    # {"SourceFile"=>"/Users/jeffmcfadden/code/green_shed_press/test/data/test_site_01/_photos/a_walk_in_the_park/DSC01626.jpg", "ExifToolVersion"=>12.7, "FileName"=>"DSC01626.jpg", "Directory"=>"/Users/jeffmcfadden/code/green_shed_press/test/data/test_site_01/_photos/a_walk_in_the_park", "FileSize"=>"262 kB", "FileModifyDate"=>"2024-09-09 09:21:10", "FileAccessDate"=>"2024-09-21 13:49:29", "FileInodeChangeDate"=>"2024-09-14 16:04:37", "FilePermissions"=>"-rw-r--r--", "FileType"=>"JPEG", "FileTypeExtension"=>"jpg", "MIMEType"=>"image/jpeg", "JFIFVersion"=>1.01, "ExifByteOrder"=>"Big-endian (Motorola, MM)", "Make"=>"SONY", "Model"=>"ILCE-7RM4A", "Orientation"=>"Horizontal (normal)", "XResolution"=>240, "YResolution"=>240, "ResolutionUnit"=>"inches", "Software"=>"Adobe Photoshop Lightroom Classic 13.5 (Macintosh)", "ModifyDate"=>"2024-09-07 19:14:45", "ExposureTime"=>0.5, "FNumber"=>1.8, "ExposureProgram"=>"Manual", "ISO"=>400, "SensitivityType"=>"Recommended Exposure Index", "RecommendedExposureIndex"=>400, "ExifVersion"=>"0231", "DateTimeOriginal"=>"2024-09-06 18:31:16", "CreateDate"=>"2024-09-06 18:31:16", "OffsetTime"=>"-07:00", "OffsetTimeOriginal"=>"-08:00", "OffsetTimeDigitized"=>"-08:00", "ShutterSpeedValue"=>0.5, "ApertureValue"=>1.8, "BrightnessValue"=>-7.8421875, "ExposureCompensation"=>0, "MaxApertureValue"=>1.8, "MeteringMode"=>"Multi-segment", "LightSource"=>"Unknown", "Flash"=>"Off, Did not fire", "FocalLength"=>"35.0 mm", "ExifImageWidth"=>2000, "ExifImageHeight"=>1333, "FocalPlaneXResolution"=>2662.184874, "FocalPlaneYResolution"=>2662.184874, "FocalPlaneResolutionUnit"=>"cm", "FileSource"=>"Digital Camera", "SceneType"=>"Directly photographed", "CustomRendered"=>"Normal", "ExposureMode"=>"Manual", "WhiteBalance"=>"Auto", "DigitalZoomRatio"=>1, "FocalLengthIn35mmFormat"=>"35 mm", "SceneCaptureType"=>"Standard", "Contrast"=>"Normal", "Saturation"=>"Normal", "Sharpness"=>"Normal", "LensInfo"=>"35mm f/1.8", "LensModel"=>"FE 35mm F1.8", "GPSStatus"=>"Measurement Void", "GPSMapDatum"=>"WGS-84", "GPSDifferential"=>"No Correction", "XMPToolkit"=>"XMP Core 6.0.0", "Rating"=>3, "Subject"=>"3-stars", "CurrentIPTCDigest"=>"245afa45c88797db1e6719df693f96ad", "CodedCharacterSet"=>"UTF8", "ApplicationRecordVersion"=>2, "DigitalCreationTime"=>"1970-01-01 18:31:16", "DigitalCreationDate"=>"2024-09-06 00:00:00", "Keywords"=>"3-stars", "DateCreated"=>"2024-09-06 00:00:00", "TimeCreated"=>"1970-01-01 18:31:16", "IPTCDigest"=>"245afa45c88797db1e6719df693f96ad", "ProfileCMMType"=>"Apple Computer Inc.", "ProfileVersion"=>"4.0.0", "ProfileClass"=>"Display Device Profile", "ColorSpaceData"=>"RGB ", "ProfileConnectionSpace"=>"XYZ ", "ProfileDateTime"=>"2022-01-01 00:00:00", "ProfileFileSignature"=>"acsp", "PrimaryPlatform"=>"Apple Computer Inc.", "CMMFlags"=>"Not Embedded, Independent", "DeviceManufacturer"=>"Apple Computer Inc.", "DeviceModel"=>"", "DeviceAttributes"=>"Reflective, Glossy, Positive, Color", "RenderingIntent"=>"Perceptual", "ConnectionSpaceIlluminant"=>"0.9642 1 0.82491", "ProfileCreator"=>"Apple Computer Inc.", "ProfileID"=>"ecfda38e388547c36db4bd4f7ada182f", "ProfileDescription"=>"Display P3", "ProfileCopyright"=>"Copyright Apple Inc., 2022", "MediaWhitePoint"=>"0.96419 1 0.82489", "RedMatrixColumn"=>"0.51512 0.2412 -0.00105", "GreenMatrixColumn"=>"0.29198 0.69225 0.04189", "BlueMatrixColumn"=>"0.1571 0.06657 0.78407", "RedTRC"=>"(Binary data 32 bytes, use -b option to extract)", "ChromaticAdaptation"=>"1.04788 0.02292 -0.0502 0.02959 0.99048 -0.01706 -0.00923 0.01508 0.75168", "BlueTRC"=>"(Binary data 32 bytes, use -b option to extract)", "GreenTRC"=>"(Binary data 32 bytes, use -b option to extract)", "ImageWidth"=>2000, "ImageHeight"=>1333, "EncodingProcess"=>"Baseline DCT, Huffman coding", "BitsPerSample"=>8, "ColorComponents"=>3, "YCbCrSubSampling"=>"YCbCr4:2:0 (2 2)", "Aperture"=>1.8, "ImageSize"=>"2000x1333", "Megapixels"=>2.7, "ScaleFactor35efl"=>1.0, "ShutterSpeed"=>0.5, "SubSecCreateDate"=>"2024-09-06 18:31:16", "SubSecDateTimeOriginal"=>"2024-09-06 18:31:16", "SubSecModifyDate"=>"2024-09-07 19:14:45", "DateTimeCreated"=>"2024-09-06 18:31:16", "DigitalCreationDateTime"=>"2024-09-06 18:31:16", "CircleOfConfusion"=>"0.030 mm", "FOV"=>"54.4 deg", "FocalLength35efl"=>"35.0 mm (35 mm equivalent: 35.0 mm)", "HyperfocalDistance"=>"22.65 m", "LightValue"=>0.7, "LensID"=>"FE 35mm F1.8"}

    def lens
      exif["LensID"]
    end

    def camera
      "#{exif["Make"]} #{exif["Model"]}"
    end

    def focal_length
      "#{exif["FocalLength"]}"
    end

    def shutter_speed
      "#{exif["ExposureTime"]} sec"
    end

    def aperture
      "f/#{exif["FNumber"]}"
    end

    def iso
      "ISO #{exif["ISO"]}"
    end

    def captured_at
      exif["DateTimeOriginal"]
    end

    def exif
      @exif ||= JSON.parse(`exiftool -json -d "%Y-%m-%d %H:%M:%S" #{@directory}#{@filepath}`).first
    end

  end
end