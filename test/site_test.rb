class SiteTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load
  end

  def test_site_title
    assert_equal "Test Site 01", @site.title
  end

  def test_site_metadata
    assert_equal "Test Blog Author", @site.author
  end

  def test_pages_loaded
    assert_operator @site.pages.length, :>, 0
  end

  def test_posts_loaded
    assert_operator @site.posts.length, :>, 0
  end

  def test_static_files_loaded
    assert_operator @site.static_files.length, :>, 0
  end

end