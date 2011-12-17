# encoding: utf-8

class WordFrequency
  
  attr_reader :newswire, :map
  
  def initialize
    @newswire = "xin_cmn"
  end
  
  def SeqFreq(corpus,ngram)
    map = Array.new
    (0..ngram - 1).each do |i|
      map[i] = Hash.new(0)
    end
    File.open(corpus, "r:UTF-8") do |file|
      temp = []
      file.each_line do |line|
        for i in (0..line.length - 1)
          char = line[i]
          if temp.length == ngram
            temp.shift
          end
          temp.push(char)
          puts temp.length
          for j in (0..temp.length - 1)
            puts temp[(temp.length - 1 - j), (j + 1)]
            map[j][temp[(temp.length - 1 - j), (j + 1)]] += 1
          end
        end
      end
    end
    for i in (0..ngram - 1)
      puts map[i].size;
    end
  end
  
  def AVFreq(ngram)
    
    @map = Array.new(ngram){Hash.new}
    (1991..2004).each do |y|
      (1..12).each do |m|
        corpus = "corpus/#{@newswire}_2/#{@newswire}_#{y}#{format("%02d", m)}_2"
        # scorpus = "corpus/xin_cmn_2/xin_cmn_199101_2"
        File.open(corpus, "r:UTF-8") do |file|
          stamp = Time.now
          temp = 0
          file.each_line do |line|
            for i in (0..line.length - 1)
              char = line[i]
              if temp == ngram
                temp = temp - 1
              end
              temp = temp + 1
              for j in (0..temp - 1)
                s = i - j
                l = j + 1
                sequence = line[s, l]
                # puts "seq : #{sequence}"
                if @map[j][sequence] == nil
                  @map[j][sequence] = Array.new(2){Hash.new(0)}
                end
                # puts "map#{j} and length #{sequence.length}"
                if s == 0
                  @map[j][sequence][1][line[s + l]] += 1
                  # puts line[s + l]
                elsif s + l == line.length
                  @map[j][sequence][0][line[s - 1]] += 1
                  # puts line[s - 1]
                else
                  @map[j][sequence][0][line[s - 1]] += 1
                  @map[j][sequence][1][line[s + l]] += 1
              # puts line[s - 1] + "/" + line[s + l] 
                end
              end
            end
          end
          puts "#{corpus}: #{Time.now - stamp}s"
          puts "#{@map[0].count} #{@map[1].count} #{@map[2].count}"
        end
      end
    end
    
    puts @map[2]["国务院"][0].count;
    puts @map[2]["国务院"][1].count;       
    
    puts @map[1]["务院"][0].count;
    puts @map[1]["务院"][1].count;
      
    puts @map[0]["院"][0].count;
    puts @map[0]["院"][1].count;   
         
  end
  
  def AVRetri
    File.open("train-4tag-r.txt", "w:UTF-8") do |fileo|
      File.open(corpus, "r:UTF-8") do |file|
        file.each_line.with_index do |line|
          char = line.split[0]
          if char == "\n" || char == nil || char == ""
            temp = ""
          else
            temp += char
            printline = char
  end
  
end

w = WordFrequency.new
w.AVFreq(3)
