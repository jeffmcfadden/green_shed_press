some_words = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape", "honeydew", "kiwi", "lemon", "mango", "nectarine", "orange", "pear", "quince", "raspberry", "strawberry", "tangerine", "ugli", "watermelon", "xigua", "yuzu", "zucchini"]

(1..10000).each do |n|
  File.open("./test/data/test_lots_of_posts/post_#{n}.md", "w") do |f|
    f.puts "---"
    f.puts "title: Post #{n}"
    f.puts "date: 2024-09-01 12:00:00"
    f.puts "tags: [tag1, tag2]"
    f.puts "draft: false"
    f.puts "---"
    f.puts "This is post #{n}.\n"
    100.times{ f.puts some_words.sample }
  end
end