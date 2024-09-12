class CollectionObjectsTest < TLDR

  def test_collection_object_types_registered
    assert_equal [GSP::Layout, GSP::Page, GSP::Partial, GSP::Post, GSP::StaticFile], GSP.collection_object_types
  end
end