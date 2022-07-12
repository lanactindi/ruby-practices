# frozen_string_literal: true

require 'etc'
require 'optparse'

class WC
  def initialize
    opt = OptionParser.new
    @option = {}

    opt.on('-l') { |v| @option[:l] = v }
    opt.on('-w') { |v| @option[:w] = v }
    opt.on('-c') { |v| @option[:c] = v }
    opt.parse!(ARGV)
  end

  def handling_file_data(file_data, file_name = nil)
    word_count_result = []
    word_count_result << file_data.split("\n").length if @option[:l] || @option.empty?
    word_count_result << file_data.split.length if @option[:w] || @option.empty?
    word_count_result << file_data.bytesize if @option[:c] || @option.empty?
    word_count_result << file_name
  end

  def exec
    buffer = $stdin.read if ARGV.empty?
    return handling_buffer(buffer) if buffer

    word_count_results = ARGV.map do |argv|
      file = File.open(argv)
      file_data = file.read
      handling_file_data(file_data, argv)
    end
    word_count_results.map do |result|
      str = '%5s'.rjust(10) * result.length
      puts(str % result)
    end
    return unless word_count_results.length > 1

    total = word_count_results.transpose.map { |a| a.reduce(:+) }
    total[-1] = 'total'
    str = '%5s'.rjust(10) * total.length
    puts(str % total)
  end

  def handling_buffer(buffer)
    result = handling_file_data(buffer)
    str = '%5s'.rjust(10) * result.length
    puts(str % result)
  end
end

WC.new.exec
