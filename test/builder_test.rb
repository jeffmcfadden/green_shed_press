class BuilderTest < TLDR
  def test_build_doesnt_blow_up
    input_directory = "./test/data/test_site_01"
    Dir.mktmpdir do |output_directory|

      assert_silent {
        builder = GSP::Builder.new(data_directory: input_directory, output_directory: output_directory)
        builder.load
        builder.build
      }

    end
  end
end