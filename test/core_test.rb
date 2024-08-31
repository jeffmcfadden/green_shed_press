class CoreTest < TLDR
  def test_that_files_load
    assert_silent { GSP::VERSION }
  end
end