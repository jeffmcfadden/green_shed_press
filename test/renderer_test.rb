class RendererTest < TLDR

  def setup
    @data_directory = File.join("test", "data", "test_site_01")
    @site = GSP::Site.new(config: File.join(@data_directory, "site.yml"))
    @site.load
  end


  def test_basic_rendering
    page   = @site.page(titled: "Home")
    output = @site.render(template: page, context: OpenStruct.new(page: page ))

    assert_equal "<!doctype html>\n<html>\n<head>\n  <title>Home</title>\n</head>\n<body>\n\n<p>Hello World!</p>\n\n</body>\n</html>", output
  end

  def test_rendering_page_with_markdown
    page     = @site.page(titled: "About")
    output   = @site.render(template: page, context: OpenStruct.new(page: page ))

    expected_body = "<!doctype html>\n<html>\n<head>\n  <title>About</title>\n</head>\n<body>\n\n<p>About <strong>me</strong></p>\n\n<p>I was born in a <em>small</em> town in the middle of nowhere.</p>\n\n</body>\n</html>"

    assert_equal expected_body, output.strip
  end

  def test_rendering_page_with_layout
    page   = @site.page(titled: "I have a layout")
    output = @site.render(template: page, context: OpenStruct.new(page: page ))

    expected_body = "<!doctype html>\n<html>\n<head>\n  <title>I have a layout</title>\n\n  <meta property=\"og:title\" content=\"I have a layout\" />\n<meta property=\"og:image\" content=\"\" />\n\n\n</head>\n<body>\n<p>This is a simple page that uses a layout.</p>\n\n</body>\n</html>"

    assert_equal expected_body, output.strip
  end

  def test_rendering_nested_layouts
    page   = @site.page(titled: "I have nested layouts")
    output = @site.render(template: page, context: OpenStruct.new(page: page ))

    expected_body = "<!doctype html>\n<html>\n<head>\n  <title>I have nested layouts</title>\n</head>\n<body>\n  <article>\n  <h1>I have nested layouts</h1>\n  <p>This is a page that uses nested layouts.</p>\n\n</article>\n</body>\n</html>"

    assert_equal expected_body, output.strip
  end


end