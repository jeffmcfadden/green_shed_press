class SiteGenerationTest < TLDR

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

  def test_static_files_written
    assert_equal true, File.exist?(File.join(@tmpdir, "static_test.txt"))
  end

  def test_assets_written
    assert_equal true, File.exist?(File.join(@tmpdir, "assets", "main.css"))
  end

  def test_site_yml_skipped
    assert_equal false, File.exist?(File.join(@tmpdir, "site.yml"))
  end


end