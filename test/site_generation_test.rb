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

  def test_post_file_written
    assert_equal true, File.exist?(File.join(@tmpdir, "posts", "hello_world.html"))

    html = "<!doctype html>\n<html>\n<head>\n  <title>Hello World</title>\n</head>\n<body>\n<article>\n  <h1>Foo</h1>\n\n<p>This is a foo. Hello people.</p>\n\n</article>\n</body>\n</html>"

    assert_equal html, File.open(File.join(@tmpdir, "posts", "hello_world.html")).read
  end

  def test_slugged_page_file_written
    assert_equal true, File.exist?(File.join(@tmpdir, "i", "am", "slugged.html"))
  end

  def test_slugged_page_as_index_file_written
    assert_equal true, File.exist?(File.join(@tmpdir, "i", "am", "at", "index.html"))
  end

  def test_draft_posts_arent_published
    assert_equal false, File.exist?(File.join(@tmpdir, "posts", "draft.html"))
  end



end