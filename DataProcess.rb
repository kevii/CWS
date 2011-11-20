# encoding: utf-8
require './AVFeature.rb'

class DataProcess

  def process(corpus, l)
    stamp = Time.now
    av = Hash.new()
    af = AVFeature.new("xin_cmn")
    File.open("train-4tag-r.txt", "w:UTF-8") do |fileo|
    File.open(corpus, "r:UTF-8") do |file|
      temp = ""
      file.each_line.with_index do |line, index|
        puts index
        if(line[0] == "\n") 
          temp = ""
          fileo.puts 
        elsif
          temp += line[0]
	        outputline = "#{line[0]} "
#          puts temp.length
#          puts "uni, bi: #{temp[2]}, #{temp[1..2]}, #{temp[0..2]}"
          (1..l).each do |i|
            if(temp.length == i)
              (0..i-1).each do |j|
                if(av[temp[i-1-j..i - 1]] == nil)
                  # puts i
                  av[temp[i-1-j..i - 1]] = af.process(temp[i-1-j..i - 1])  
                elsif
                  puts "Existed pattern:#{temp[i-1-j..i- 1]}: av#{av[temp[i-1-j..i - 1]]}"
                end
                outputline += "#{format("% 6d", av[temp[i-1-j..i - 1]][0])} #{format("% 6d", av[temp[i-1-j..i - 1]][1])} " 
              end
              if(i == l)
                temp = temp[1..i-1]
              end
            end
          end
          outputline += "#{format("% 6s",line.split[1])}"
          fileo.puts outputline
        end
        # puts "line: #{index}"
      end
    end
    end
    puts av.count
    puts "total consumed time: #{Time.now - stamp}s"
  end
end

p = DataProcess.new
p.process("train-4tag.txt", 3)


