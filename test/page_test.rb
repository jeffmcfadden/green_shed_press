class PageTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load

    @page = @site.page(titled: "The bee's knees")
  end

  def test_page
    assert_kind_of GSP::Page, @page

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
    page = @site.page(titled: "Home")
    assert_equal "Home", page.title
  end

  def test_untitled_page
    page = @site.page(titled: "About")
    assert_nil page
  end

  def test_layout_loaded
    page = @site.page(titled: "I have a layout")
    assert_equal "layout_01", page.layout
  end


end