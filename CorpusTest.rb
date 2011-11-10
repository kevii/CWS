# encoding: utf-8
# require 'xml/libxml'


# i = 0
# File.open("chinesecorpus.txt") do |file|
  # # file.each_line {|line|  puts line.class}
  # puts file.each_line {|line| puts line[0]}
# end

# parser = XML::Parser.file('xin_cmn_199101')
# doc = parser.parse
# node = doc.find_first('/HEADLINE')
# puts node.name
def process(newswire, version)
  (1991..2004).each do |i|
    (1..12).each do |j|
      if j < 10
        corpus = "#{newswire}_#{i}0#{j}"
      else
        corpus = "#{newswire}_#{i}#{j}"
      end
      File.open("corpus/#{newswire}_#{version}/#{corpus}_#{version}", "w:UTF-8") do |file|
        File.open("corpus/#{newswire}/#{corpus}", "r:UTF-8") do |file1|
          file1.each_line do |line|
            if line =~ /<HEADLINE>/ .. line =~ /<\/HEADLINE>/
              if line !~ /<HEADLINE>|<\/HEADLINE>/
                file.puts line[0..line.length - 2]
              end
            elsif line =~ /<TEXT>/ .. line =~ /<\/TEXT>/
              if line !~ /<P>|<\/P>|<TEXT>|<\/TEXT>/
                file.print line[0..line.length - 2]
              elsif line =~ /<\/P>/
                file.puts ""
              end
            end
          end
        end
      end
    end
  end
end

process("xin_cmn", 2)

