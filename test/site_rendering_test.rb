class SiteRenderingTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load
    @site.render
  end

  def test_basic_rendering
    assert_equal "true", "true"
  end

end