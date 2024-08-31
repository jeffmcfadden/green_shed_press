class PageTest < TLDR
  def test_page
    page = GSP::Page.load(File.join('test', 'data', 'page_1.md'))

    assert_equal 637, page.body.length
    assert_equal "The bee's knees", page.title
  end

  def test_custom_frontmatter
    page = GSP::Page.load(File.join('test', 'data', 'page_1.md'))

    assert_equal "A funky value", page.funky
  end

end