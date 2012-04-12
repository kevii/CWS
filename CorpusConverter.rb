# encoding: utf-8


class CorpusConverter

  attr_reader :tagSetType, :inputFile, :outputFile

  def initialize(tagSetType, inputFile, outputFile)
    @tagSetType = tagSetType
    @inputFile  = inputFile
    @outputFile = outputFile
  end

  def process
    File.open(@outputFile, "w:UTF-8") do |file|
      File.open(@inputFile, "r:UTF-8") do |file1|
        file1.each_line do |line|
          word = (line.split(" "))[1]
          if(word)
            tempTag = tagSet(word)
            (0..(word.length - 1)).each do |i|
              tempRow = tempTag.assoc(word.chars.to_a[i])
              file.puts "#{tempRow[0]}  #{tempRow[1]}"
            end
          else
            file.puts "EOS  S"
	          file.puts "BOS  S"
          end
        end
      end
    end
  end

  def tagSet(word)
    wordTag = Hash.new()
    (0..(word.length - 1)).each do |i|
      wordTag[word.chars.to_a[i]] = (getTagSeq(word))[i]
    end
    return wordTag
  end

  def getTagSeq(word)
    case @tagSetType
      when 2

      when 4
        case word.length
          when 0
            tagSeq = []
          when 1
            tagSeq = ["S"]
          when 2
            tagSeq = ["B", "E"]
          else
            tagSeq = ["B", "E"]
            tempSeq = []
              (0..(word.length - 3)).each do
                tempSeq = tempSeq + ["M"]
              end
            tagSeq[1,0] = tempSeq
        end
      when 6
        case word.length
          when 0
            tagSeq = []
          when 1
            tagSeq = ["S"]
          when 2
            tagSeq = ["B", "E"]
          when 3
            tagSeq = ["B", "B1", "E"]
          when 4
            tagSeq = ["B", "B1", "B2", "E"]
          else
            tagSeq = ["B", "B1", "B2", "E"]
            tempSeq = []
              (0..(word.length - 5)).each do
                tempSeq = tempSeq + ["M"]
              end
            tagSeq[3,0] = tempSeq
        end
    end
    return tagSeq
  end

end

# word = "财经郎闲评"
cor =  CorpusConverter.new(4, "CoNLL2009-ST-Chinese-train.txt", "testfile1.txt")
puts cor.process

