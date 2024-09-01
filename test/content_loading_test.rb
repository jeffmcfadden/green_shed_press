class ContentLoadingTest < TLDR
  def test_loading_page
    page = GSP::Page.load(File.join('test', 'data', 'page_1.md'))

    assert_equal "The bee's knees", page.title
    assert_equal 637, page.body.length
  end

end