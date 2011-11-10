# counts = Hash.new(0)
# File.foreach("testfile") do |line|
  # line.scan(/\w+/) do |word|
    # word = word.downcase
    # counts[word] += 1
  # end
# end
words = Fiber.new do
  File.foreach("testfile") do |line|
    line.scan(/\w+/) do |word|
      Fiber.yield word.downcase
    end
  end
end
counts = Hash.new(0)
while word = words.resume
  counts[word] += 1
end

counts.keys.sort.each {|k| print "#{k}:#{counts[k]} "}
