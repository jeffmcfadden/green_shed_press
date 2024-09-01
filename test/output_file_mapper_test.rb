class OuputFileMapperTest < TLDR
  def test_output_file_mapper
    output_file_mapper = GSP::OutputFileMapper.new(data_directory: 'test/data', output_directory: 'test/output')

    expected_map = {
      'test/data/css/main.css' => 'test/output/css/main.css',
      'test/data/index.md' => 'test/output/index.html',
      'test/data/posts/that_one_time_at_band_camp.md' => 'test/output/posts/that_one_time_at_band_camp.html',
    }

    expected_map.each do |input_filename, expected_output_filename|
      assert_equal expected_output_filename, output_file_mapper.output_filename(filename: input_filename)
    end
  end
end