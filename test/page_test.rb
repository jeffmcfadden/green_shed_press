class PageTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load

    @page = GSP::Page.new(file: GSP::GSPFile.new(path: File.join(@site.data_directory, "pages", "page_1.md"), site: @site))
  end

  def test_page
    assert_equal 637, @page.body.length
    assert_equal "The bee's knees", @page.title
  end

  def test_custom_frontmatter
    assert_equal "A funky value", @page.funky
  end

  def test_body_loaded
    assert_equal 637, @page.body.length
  end

  def test_find_by_title
    assert_equal "Home", @site.page(titled: "Home").title
  end

  def test_title_from_frontmatter
    page = GSP::Page.new(file: GSP::GSPFile.new(path: File.join(@site.data_directory, "pages", "home.md"), site: @site))
    assert_equal "Home", page.title
  end

  def test_title_from_filename
    page = GSP::Page.new(file: GSP::GSPFile.new(path: File.join(@site.data_directory, "pages", "about.md"), site: @site))
    assert_equal "About", page.title
  end

  def test_layout_loaded
    page = GSP::Page.new(file: GSP::GSPFile.new(path: File.join(@site.data_directory, "pages", "page_with_layout.md"), site: @site))
    assert_equal "layout_01", page.layout
  end


end