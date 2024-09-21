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

  def test_full_size_photo_created
    assert_equal true, File.exist?(File.join(@tmpdir, "photos", "a_walk_in_the_park", "DSC01626_full.jpg"))
  end

end