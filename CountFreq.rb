# encoding: utf-8

class CountFreq
  
  attr_reader :text
  
  def initialize
    @text = "output1"
  end
  
  def process
    getFreq(@text, 3)
  end
  
  def getFreq(rawtext, n)
    counts = Array.new
    (0..n).each do |i|
      counts[i] = Hash.new(0)
    end
    temp = []
    File.open(rawtext, "r:UTF-8") do |file|
      file.each_line do |line|
        
        
        
        
        word = line.split[0]
        # puts word
        # puts temp.length
          if temp.length == n
            temp.shift
          end
          temp.push(word)
          
          for i in (0..temp.length - 1)
            counts[i][temp[(temp.length - 1 - i),(i + 1)]] += 1
          end
      end
    end
    re =[]
    re[0] = counts[0].sort_by{|word, count| count}.last(50)
    re[1] = counts[1].sort_by{|word, count| count}.last(50)
    re[2] = counts[2].sort_by{|word, count| count}.last(50)
    
    puts counts[0].size
    puts counts[1].size
    puts counts[2].size
    
    for i in 0..3
      for j in 0..50
        word = re[i][j]
        puts "#{word}"
      end
    end
    
    
  end

  def words_from_line(line)
    line.downcase.scan(/[\w']+/)
  end
   
  def convert
    File.open("treetext", "w:UTF-8") do |filew|
      File.open(@text, "r:UTF-8") do |filer|
        filer.each_line do |line|
        
          word_list = line.split
          
          for word in word_list
            filew.puts word
          end
          
        end
      end
    end
  end
   
end

f = CountFreq.new
f.process