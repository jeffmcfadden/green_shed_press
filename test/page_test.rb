class PageTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))

    @page = GSP::Page.new(file: GSP::GSPFile.new(path: File.join(@site.data_directory, "pages", "page_1.md"), site: @site))
  end

  def test_page
    assert_equal 637, @page.body.length
    assert_equal "The bee's knees", @page.title
  end

  def test_custom_frontmatter
    assert_equal "A funky value", @page.funky
  end

end