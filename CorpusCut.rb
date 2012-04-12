# encoding: utf-8

class CorpusCut

  def process(filename, ratio)
    corpusline = 1026542
    File.open("cws-train1.txt", "w:UTF-8") do |trainout|
      File.open("cws-test1.txt", "w:UTF-8") do |testout|
        File.open(filename, "r:UTF-8") do |file|
          file.each_line.with_index do |line, index|
            r = index.to_f / corpusline
            if r <= ratio
              trainout.puts line
            else
              testout.puts line
            end
          end
        end
      end
    end
  end

end

c = CorpusCut.new
c.process('train-4tag-r2.txt', 0.75)

