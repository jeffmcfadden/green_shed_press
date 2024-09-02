class RendererTest < TLDR

  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @tmpdir
  end

  def test_basic_rendering
    renderer = GSP::Renderer.new(data_directory: "test/data/test_site_01", output_directory: @tmpdir)
    page = GSP::Page.load("test/data/test_site_01/pages/home.md")
    site = GSP::Site.load("test/data/test_site_01/site.yml")

    output = renderer.render(page, context: OpenStruct.new(site: site, page: page ))

    assert_equal "<p>Hello World!</p>\n", output
  end

  def test_rendering_page_with_markdown
    renderer = GSP::Renderer.new(data_directory: "test/data/test_site_01", output_directory: @tmpdir)
    page = GSP::Page.load("test/data/test_site_01/pages/about.md")
    site = GSP::Site.load("test/data/test_site_01/site.yml")

    output = renderer.render(page, context: OpenStruct.new(site: site, page: page ))

    expected_body = "<p>About <strong>me</strong></p>\n\n<p>I was born in a <em>small</em> town in the middle of nowhere.</p>"

    assert_equal expected_body, output.strip
  end

  def test_rendering_page_with_layout
    renderer = GSP::Renderer.new(data_directory: "test/data/test_site_01", output_directory: @tmpdir)
    page = GSP::Page.load("test/data/test_site_01/pages/page_with_layout.md")
    site = GSP::Site.load("test/data/test_site_01/site.yml")

    output = renderer.render(page, context: OpenStruct.new(site: site, page: page ))

    expected_body = "<!doctype html>\n<html>\n<head>\n  <title>I have a layout</title>\n\n  <meta property=\"og:title\" content=\"I have a layout\" />\n<meta property=\"og:image\" content=\"\" />\n\n\n</head>\n<body>\n<p>This is a simple page that uses a layout.</p>\n\n</body>\n</html>"

    assert_equal expected_body, output.strip
  end

  def test_rendering_nested_layouts
    renderer = GSP::Renderer.new(data_directory: "test/data/test_site_01", output_directory: @tmpdir)
    page = GSP::Page.load("test/data/test_site_01/pages/page_with_nested_layout.md")
    site = GSP::Site.load("test/data/test_site_01/site.yml")

    output = renderer.render(page, context: OpenStruct.new(site: site, page: page ))

    expected_body = "<!doctype html>\n<html>\n<head>\n  <title>I have nested layouts</title>\n</head>\n<body>\n  <article>\n  <h1>I have nested layouts</h1>\n  <p>This is a page that uses nested layouts.</p>\n\n</article>\n</body>\n</html>"

    assert_equal expected_body, output.strip
  end


end