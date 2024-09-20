class PostsTest < TLDR

  def setup
    @draft_post = GSP::Post.new(File.join("test", "data", "test_site_01", "_posts", "draft_post.md"))
  end

  def test_draft_status
    assert_equal true, @draft_post.draft?
  end

end