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
    assert_equal true, File.exist?(File.join(@tmpdir, "assets", "main.css"))
  end

  def test_assets_written
    assert_equal true, File.exist?(File.join(@tmpdir, "assets", "main.css"))
  end

  def test_site_yml_skipped
    assert_equal false, File.exist?(File.join(@tmpdir, "site.yml"))
  end

  def test_post_file_written
    assert_equal true, File.exist?(File.join(@tmpdir, "posts", "hello_world.html"))

    html = "<!doctype html>\n<html>\n<head>\n  <title>Hello World</title>\n</head>\n<body>\n<article>\n  \n<h1 id=\"foo\">Foo</h1>\n\n<p>This is a foo. Hello people.</p>\n\n</article>\n</body>\n</html>"

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

  def test_syntax_highlighting
    html = File.open(File.join(@tmpdir, "posts", "i_have_code.html")).read
    assert_equal true, html.include?('<code><span class="k">def</span> <span class="nf">hello</span>')
  end

  def test_paginated_posts
    assert_equal true, File.exist?(File.join(@tmpdir, "posts", "page_2.html"))
  end

  def test_micro_post_created
    assert_equal true, File.exist?(File.join(@tmpdir, "micro_posts", "2024-09-01-000001.html"))
  end

  def test_book_micropost_created
    assert_equal true, File.exist?(File.join(@tmpdir, "micro_posts", "2024-06-19-the_way_of_kings.html"))
  end

  def test_book_post_created
    assert_equal true, File.exist?(File.join(@tmpdir, "bookshelf", "the_way_of_kings.html"))
  end

  def test_date_with_hyphens_from_filename
    mp_1 = @site.micro_posts.find{ |mp| mp.basename(".*") == "2024-08-30" }
    assert_equal Date.parse("2024-08-30"), mp_1.date_from_filename
  end

  def test_date_with_time_from_filename
    mp_2 = @site.micro_posts.find{ |mp| mp.basename(".*") == "2024-09-01-000001" }
    assert_equal Time.parse("2024-09-01 00:00:01"), mp_2.date_from_filename
  end

  def test_date_with_underscores_from_filename
    mp_3 = @site.micro_posts.find{ |mp| mp.basename(".*") == "2024_08_29-blah" }
    assert_equal Date.parse("2024-08-29"), mp_3.date_from_filename
  end




end