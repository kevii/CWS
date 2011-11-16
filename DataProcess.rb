# encoding: utf-8
require './AVFeature.rb'

class DataProcess

  def process(corpus, l)
    av = Hash.new()
    af = AVFeature.new("xin_cmn")
    File.open(corpus, "r:UTF-8") do |file|
      temp = ""
      file.each_line.with_index do |line, index|
        if(line[0] == "\n") 
          temp = ""
        elsif
          temp += line[0]
          puts "uni, bi: #{temp[2]}, #{temp[1..2]}, #{temp[0..2]}"
	  ((l - 1)..0).each do |i|
	    
#          if(temp.length == l)
            if(av[temp[i..(l - 1)]] == nil)
              av[temp[i..(l - 1)]] = af.process(temp)
            elsif
              puts "Existed pattern:#{temp}: av#{av[temp[i..(l - 1)]]}"
              i += 1
            end
#	    puts temp
            temp = temp[1..(l-1)]
          end
        end
        # puts "line: #{index}"
      end
    end
    puts av.count
  end 
end

p = DataProcess.new
p.process("train-4tag.txt", 3)


