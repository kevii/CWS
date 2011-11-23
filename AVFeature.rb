# encoding: utf-8

class AVFeature
  
  attr_reader :newswire
  
  def initialize(newswire)
    @newswire = newswire
  end
  
  def process(pattern)
    av = [Hash.new(0), Hash.new(0)]
    stamp = Time.now
#    threads = []
    (1991..2004).each do |i|
      (1..12).each do |j|
        corpus = ""
        if j < 10
          corpus = "corpus/#{@newswire}_2/#{@newswire}_#{i}0#{j}_2"
        else
          corpus = "corpus/#{@newswire}_2/#{@newswire}_#{i}#{j}_2"
        end
#        threads << Thread.new(corpus) do |t|
        File.open(corpus, "r:UTF-8") do |file|
          file.each_line do |line|
            flag = line.index(pattern)
            if(flag && flag != 0 && flag < (line.length - pattern.length))
              av[0][line[flag - 1]] += 1
              av[1][line[flag + pattern.length]] += 1
            elsif(flag && flag == 0)
              av[1][line[flag + pattern.length]] += 1
            elsif(flag && flag == (line.length - pattern.length))
              av[0][line[flag - 1]] += 1
            end
          end
        end
#        end
      end
    end
#    threads.each {|thr| thr.join} 
    puts "time: #{Time.now - stamp}s"
#    puts "pattern: #{pattern}: av[#{av[0].count}, #{av[1].count}]"
    avc = [av[0].count, av[1].count]
    yield avc
    return avc
  end
  
  def process_2(patterns)
    avArray = Hash.new
    stamp = Time.now
    (1991..2004).each do |i|
      (1..12).each do |j|
        corpus = ""
        if j < 10
          corpus = "corpus/#{@newswire}_2/#{@newswire}_#{i}0#{j}_2"
        else
          corpus = "corpus/#{@newswire}_2/#{@newswire}_#{i}#{j}_2"
        end
        File.open(corpus, "r:UTF-8") do |file|
          file.each_line do |line|
            patterns.each do |pattern|
              flag = line.index(pattern)
              if(flag && flag != 0 && flag < (line.length - pattern.length))
                lav[line[flag - 1]] += 1
                rav[line[flag + pattern.length]] += 1
              elsif(flag && flag == 0)
                rav[line[flag + pattern.length]] += 1
              elsif(flag && flag == (line.length - pattern.length))
                lav[line[flag - 1]] += 1
              end
              avArray
            end
          end
        end
#        puts "#{corpus} completed..\n"
      end
    end
    puts "time: #{Time.now - stamp}s"
    puts "pattern: #{format("% 5s", pattern)}: lav = #{lav.count} , rav = #{rav.count}"
    return [lav.count, rav.count]
  end
  
  #ordinary search algorithm
  def search(pattern, corpus)
    
    File.open(corpus, "r:UTF-8") do |file|
      offset = 0
      file.each_line do |line|
        puts "offset at begin: #{offset}"
        puts "length of each line: #{line.length}"
        flag = offset
        (0..(line.length - 2)).each do |i|
          puts "#{line[i]} - #{pattern[offset]}"
          
          if(pattern[offset] == line[i])
            found = true
            offset += 1
            temp = 0
            puts "offset: #{offset}"
            (offset..(pattern.length - 1)).each do |j|
              puts ":) #{i}:#{i + j}:#{line.length - 2}"
              if((i + j) <= (line.length - 2))
                if(i == 0 && flag != 0)
                  temp = flag
                else
                  temp = 0
                end
                puts "---#{j}:#{i+j-temp}:#{line[i+j-temp]} - #{pattern[j]}"
                if(pattern[j] != line[i + j - temp])
                  # puts "Dif loc: #{i + j - temp}"
                  found = false
                  offset = 0
                  break
                end
                offset += 1
                puts "offset: #{offset}"
              end
            end
            if(found == true && offset == pattern.length)
              offset = 0
              puts "found: #{i - temp}"
            end
          end
        end
      end
    end
  end
  
  def search_2(pattern, corpus)
    stamp = Time.now
    File.open(corpus, "r:UTF-8") do |file|
      text = ""
      file.each_line do |line|
        if line =~ /<TEXT>/ .. line =~ /<\/TEXT>/
          if line !~ /<TEXT>|<\/TEXT>/
            text += line[0..line.length-2]
          elsif line =~ /<\/TEXT>/
            result = searchText(pattern, text)
            text = ""
          end
        end  
        # searchText(pattern, line)
      end
    end
    puts "Time consume: #{Time.now - stamp}s"
  end
  
  def searchText(pattern, text)
    (0..(text.length - pattern.length)).each do |i|
      if(pattern[0] == text[i])
        found = true
        (1..(pattern.length - 1)).each do |j|
          if(pattern[j] != text[i + j])
            found = false
            break
          end
        end
        if(found == true)
          if(i != 0 && i < (text.length - pattern.length))
            @lav[text[i - 1]] += 1
            @rav[text[i + pattern.length]] += 1
          end
        end
      end
    end
  end
  
  def search_3(pattern, corpus)
#    stamp = Time.now
    File.open(corpus, "r:UTF-8") do |file|
      file.each_line do |line|
        # searchText_2(pattern, line)
        flag = line.index(pattern)
        if(flag && flag != 0 && flag < (line.length - pattern.length))
          @lav[line[flag - 1]] += 1
          @rav[line[flag + pattern.length]] += 1
        end
      end
    end
#    puts "Time consume: #{Time.now - stamp}s"
  end
  
  def searchText_2(pattern, text)
#    puts "#{pattern} : #{text}"
#    puts ""
    flag = text.index(pattern)
    if(flag && flag != 0 && flag < (text.length - pattern.length))
      @lav[text[flag - 1]] += 1
      @rav[text[flag + pattern.length]] += 1
    end
  end
end

# f = AVFeature.new("xin_cmn")
# f.process(",")
# f.search_3("新加坡", "corpus/xin_cmn_p/xin_cmn_199101_1")


