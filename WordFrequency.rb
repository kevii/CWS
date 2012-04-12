# encoding: utf-8

class WordFrequency

  attr_reader :newswire, :map, :ngram

  def initialize(newswire, ngram)
    @newswire = newswire
    @ngram = ngram
  end

  def SeqFreq(corpus)
    map = Array.new
    (0..ngram - 1).each do |i|
      map[i] = Hash.new(0)
    end
    File.open(corpus, "r:UTF-8") do |file|
      temp = []
      file.each_line do |line|
        for i in (0..line.length - 1)
          char = line[i]
          if temp.length == @ngram
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
    for i in (0..@ngram - 1)
      puts map[i].size;
    end
  end

  ##  Calculate the ngram av freqency and store it into hashmaps
  ##
  def AVFreq

    @map = Array.new(@ngram){Hash.new}
#    (1991..2004).each do |y|
#      (1..12).each do |m|
#        corpus = "corpus/#{@newswire}_2/#{@newswire}_#{y}#{format("%02d", m)}_2"
#        corpus = "corpus/#{@newswire}_2/#{@newswire}_1991#{format("%02d", m)}_2"
        corpus = "corpus/#{@newswire}_2/#{@newswire}_199101_2"
        File.open(corpus, "r:UTF-8") do |file|
          stamp = Time.now
          temp = 0
          file.each_line do |line|
            for i in (0..line.length - 1)
              char = line[i]
              if temp == @ngram
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
#          puts "#{@map[0].count} #{@map[1].count} #{@map[2].count}"
        end
#      end
#    end

#    puts @map[2]["国务院"][0].count;
#    puts @map[2]["国务院"][1].count;

#    puts @map[1]["务院"][0].count;
#    puts @map[1]["务院"][1].count;

#    puts @map[0]["院"][0].count;
#    puts @map[0]["院"][1].count;

  end

  ##   retrive av freqency from hashmaps
  ##
  def AVRetri(input, output)
    stamp = Time.now
    File.open(output, "w:UTF-8") do |fileo|
      File.open(input, "r:UTF-8") do |file|
	      temp = Array.new
        file.each_line do |line|
          current_token = line.split[0]
          current_tag = line.split[1]
          if line == "\n"
            temp = []
	          fileo.puts ""
          else
            puts "temp: #{temp}"
	          if temp.length == @ngram
	            temp.shift
	          end
            temp.push(current_token)
	          printline = current_token
	          if current_token == "，"
              current_token = ","
	          end
            puts "current_token: #{current_token}"
            puts "current_token: #{current_tag}"
            puts "temp: #{temp}"
	          sequence = String.new
	          l = temp.length
	          for i in (1..l)
#	            sequence = temp[-i] + sequence
              sequence += temp[i - 1]
              # puts sequence into screen
	            puts sequence
              puts "t: #{temp}"
              if @map[i][sequence] != nil
	              if @map[i][sequence][0] != nil
	                lav = @map[i][sequence][0].count
	              else
                  lav = 0
	              end
                if @map[i][sequence][1] != nil
	                rav = @map[i][sequence][1].count
	              else
                  rav = 0
                end
	            else
                lav = 0
                rav = 0
              end
	            printline += "#{format("% 6d", lav)}#{format("% 6d", rav)}"
	          end
            case @ngram
              when 2
                case l
                  when 1
                    2.times {printline += "#{format("% 6d", 0)}"}
                end
              when 3
                case l
                  when 1
                    2.times {printline += "#{format("% 6d", 0)}"}
                  when 2
                    4.times {printline += "#{format("% 6d", 0)}"}
                end
            end
 	          printline += "#{format("% 6s", current_tag)}"
	          fileo.puts printline
	        end
        end
      end
    end
    puts "#{corpus}: #{Time.now - stamp}s"
  end

end

window = 2
w = WordFrequency.new("xin_cmn", window)
w.AVFreq
w.AVRetri("train-4tag.txt", "train-4tag-w#{window}.txt")

