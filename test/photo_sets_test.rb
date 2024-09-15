class PhotoSetsTest < TLDR

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

  def test_photo_sets_loaded
    assert_equal 1, @site.photo_sets.size
  end

  def test_photos_loaded
    assert_equal 1, @site.photo_set(titled: "A Walk in the Park").photos.size
  end

  def photo_set_index_file_created
    assert_equal true, File.exist?(File.join(@tmpdir, "photo_sets", "a_walk_in_the_park", "index.html"))
  end

  def photo_files_copied_over
    assert_equal true, File.exist?(File.join(@tmpdir, "photo_sets", "a_walk_in_the_park", "DSC01626.jpg"))
  end

  def photo_page_files_created
    assert_equal true, File.exist?(File.join(@tmpdir, "photo_sets", "a_walk_in_the_park", "DSC01626.html"))
  end

end