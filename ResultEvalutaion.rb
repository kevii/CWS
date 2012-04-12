# encoding: utf-8

class ResultEvaluation

  attr_reader :input_file

  def initialize(input_file)
    @input_file = input_file
  end

  def process
    total_line = 0
    correct_line = 0
    File.open(@input_file, "r:UTF-8") do |input|
      input.each_line.with_index do |line, index|
        total_line += 1
        correct_line += 1 if line.split[-1] == line.split[-2]
      end
    end

    puts "Accuracy: #{correct_line.to_f / total_line}"
  end
end

r = ResultEvaluation.new 'cws-result.txt'
r.process

