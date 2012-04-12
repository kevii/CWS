# encoding: utf-8

class AVFeature

  attr_reader :newswire

  def initialize corpus
    @newswire = corpus
  end

  def process(pattern)
    av = [Hash.new(0), Hash.new(0)]
    stamp = Time.now
#    threads = []
    (1991..2004).each do |i|
      (1..12).each do |j|
	      corpus = "corpus/#{@newswire}_2/#{@newswire}_#{i}#{format("%02d", j)}_2"
#        threads << Thread.new(corpus) do |t|
        File.open(corpus, "r:UTF-8") do |file|
          file.each_line do |line|
            offset = 0
            while line.index(pattern,offset)
              pos = line.index(pattern, offset)
              if(pos && (line.length - pattern.length) != 0)
		            if(pos != 0 && pos < (line.length - pattern.length))
                  av[0][line[pos - 1]] += 1
                  av[1][line[pos + pattern.length]] += 1
                elsif(pos == 0)
                  av[1][line[pos + pattern.length]] += 1
                elsif(pos == (line.length - pattern.length))
                  av[0][line[pos - 1]] += 1
                end
                offset = pos + 1
              end
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
    puts avc
#   yield avc
    return avc
  end

  def process2(prray)
    map = Array.new([Hash.new(0),Hash.new(0)])
    stamp = Time.now
    (1991..2004).each do |i|
      (1..12).each do |j|
        corpus = "corpus/#{@newswire}_2/#{@newswire}_#{i}#{format("%02d", j)}_2"
        File.open(corpus, "r:UTF-8") do |file|
          file.each_line do |line|
            (0..prray.length-1).each do |index|
              pattern = prray[index]
	      puts pattern
              flag = line.index(pattern)
              if(flag && flag != 0 && flag < (line.length - pattern.length))
                map[index][0][line[flag - 1]] += 1
                map[index][1][line[flag + pattern.length]] += 1
              elsif(flag && flag == 0 && flag != (line.length - pattern.length))
                map[index][1][line[flag + pattern.length]] += 1
              elsif(flag && flag == (line.length - pattern.length) && flag != 0)
                map[index][0][line[flag - 1]] += 1
              end
            end
          end
        end
      end
    end
    (0..prray.length-1).each do |index|
      puts "pattern: #{prray[index]} -- #{map[index][0].count}/#{map[index][1].count}"
    end
    puts "time: #{Time.now - stamp}s"
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

 f = AVFeature.new "xin_cmn"
 f.process("中国进")

# f.search_3("新加坡", "corpus/xin_cmn_p/xin_cmn_199101_1")

# patternList = ["中","国","中国","进","国进","出","进出"]
# f.process2(patternList)

