class PhotosTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load
    @tmpdir = Dir.mktmpdir
    @site.generate(output_directory: @tmpdir)

    @photo_with_exif = @site.photos.first
  end

  def teardown
    FileUtils.remove_entry(@tmpdir)
  end

  def test_full_size_photo_created
    assert_equal true, File.exist?(File.join(@tmpdir, "photos", "a_walk_in_the_park", "DSC01626_full.jpg"))
  end

  def test_exif
    assert_equal "FE 35mm F1.8", @photo_with_exif.lens
    assert_equal "SONY ILCE-7RM4A", @photo_with_exif.camera
    assert_equal "35.0 mm", @photo_with_exif.focal_length
    assert_equal "0.5 sec", @photo_with_exif.shutter_speed
    assert_equal "f/1.8", @photo_with_exif.aperture
    assert_equal "ISO 400", @photo_with_exif.iso
    assert_equal "2024-09-06 18:31:16", @photo_with_exif.captured_at
  end


end