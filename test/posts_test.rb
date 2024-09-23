class PostsTest < TLDR

  def setup
    @draft_post = GSP::Post.new(directory: File.join("test", "data", "test_site_01"), filepath: File.join("_posts", "draft_post.md"))
    @post_with_no_title = GSP::Post.new(directory: File.join("test", "data", "test_site_01"), filepath: File.join("_posts", "2024-09-12_no_title.md"))
  end

  def test_draft_status
    assert_equal true, @draft_post.draft?
  end

  def test_title_fallback
    assert_equal "2024 09 12 No Title", @post_with_no_title.title
  end


end