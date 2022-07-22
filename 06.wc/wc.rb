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

  def count_file_data(file_data, file_name = nil)
    result = []
    result << file_data.split("\n").length if @option[:l] || l_w_c_options_are_all_empty?(@option)
    result << file_data.split.length if @option[:w] || l_w_c_options_are_all_empty?(@option)
    result << file_data.bytesize if @option[:c] || l_w_c_options_are_all_empty?(@option)
    result << file_name
  end

  def l_w_c_options_are_all_empty?(option)
    option[:l].nil? && option[:w].nil? && option[:c].nil?
  end

  def exec
    string_entered_from_stdin = $stdin.read if ARGV.empty?
    return print_result_for_stdin(string_entered_from_stdin) if string_entered_from_stdin

    results = ARGV.map do |argv|
      file = File.open(argv)
      file_data = file.read
      count_file_data(file_data, argv)
    end
    results.map do |result|
      str = '%5s'.rjust(10) * result.length
      puts(str % result)
    end
    return unless results.length > 1

    total = results.transpose.map(&:sum)
    total[-1] = 'total'
    puts(('%5s'.rjust(10) * total.length) % total)
  end

  def print_result_for_stdin(string_entered_from_stdin)
    result = count_file_data(string_entered_from_stdin)
    str = '%5s'.rjust(10) * result.length
    puts(str % result)
  end
end

WC.new.exec
