require_relative '../lib/green_shed_press'
require 'benchmark'

# Last time I tried this the results were just not worth it. It's slower and unlikely to be sped
# up enough to be worth it. Filesystem access is just too fast for this to be worth it.

# $ bundle exec ruby test/benchmark_post_loading.rb
# /Users/jeffmcfadden/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/io-event-1.6.5/lib/io/event/support.rb:27: warning: IO::Buffer is experimental and both the Ruby and C interface may change in the future!
# Rehearsal ------------------------------------------
# Serial   0.496870   0.172251   0.669121 (  0.673990)
# Async    0.672539   0.236870   0.909409 (  1.060689)
# --------------------------------- total: 1.578530sec
#
#              user     system      total        real
# Serial   0.504782   0.164270   0.669052 (  0.672168)
# Async    0.682071   0.215081   0.897152 (  1.012616)

base_dir = File.join("test", "data", "test_lots_of_posts")

@serial_posts = []
@async_posts = []

Benchmark.bmbm do |x|
  x.report("Serial") do
    Dir.glob("#{base_dir}/*.md").each do |file|
      post = GSP::Post.new(directory: base_dir, filepath: File.basename(file))
      @serial_posts << post unless post.draft?
    end
  end

  x.report("Async") do
    barrier = Async::Barrier.new

    Sync do
      semaphore = Async::Semaphore.new(5, parent: barrier)

      @async_posts = Dir.glob("#{base_dir}/*.md").map do |file|
        semaphore.async do
          p = GSP::Post.new(directory: base_dir, filepath: File.basename(file))
          p.draft? ? nil : p
        end
      end.map(&:wait)
    ensure
      barrier.stop
    end

    # @async_posts.compact!
    # @async_posts
  end
end