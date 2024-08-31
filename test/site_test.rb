class SiteTest < TLDR
  def test_site
    site = GSP::Site.load(File.join('test', 'data', 'site_1.yml'))

    assert_equal "Test Blog", site.title
  end
end