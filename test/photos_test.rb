class PhotosTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load
    @tmpdir = Dir.mktmpdir
    @site.generate(output_directory: @tmpdir)
  end

  def teardown
    FileUtils.remove_entry(@tmpdir)
  end

  def test_photo_file_written
    # assert_equal true, File.exist?(File.join(@tmpdir, "photos", "DSC01626.jpg"))
  end

  def test_photo_page_file_written
    # assert_equal true, File.exist?(File.join(@tmpdir, "photos", "DSC01626.jpg.html"))
  end

end