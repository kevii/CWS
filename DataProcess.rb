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
          puts temp.length
          puts "uni, bi: #{temp[2]}, #{temp[1..2]}, #{temp[0..2]}"
          (1..l).each do |i|
            if(temp.length == i)
              (0..temp.length-1).each do |j|
                if(av[temp[j..temp.length - 1]] == nil)
                  # puts i
                  av[temp[j..temp.length - 1]] = af.process(temp[j..temp.length - 1])
                elsif
                  puts "Existed pattern:#{temp[j..temp.length - 1]}: av#{av[temp[j..temp.length - 1]]}"
                end
              end
              if(i == l)
                temp = temp[1..i-1]
              end
            end
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


