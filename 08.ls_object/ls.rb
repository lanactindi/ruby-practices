# frozen_string_literal: true

require 'etc'
require 'optparse'
require_relative 'printer'

class LS
  def initialize
    opt = OptionParser.new
    @printer = Printer.new
    @option = {}

    opt.on('-a') { |v| @option[:a] = v }
    opt.on('-r') { |v| @option[:r] = v }
    opt.on('-l') { |v| @option[:l] = v }
    opt.parse!(ARGV)
  end

  def exec
    files = Dir.glob('*', @option[:a] ? File::FNM_DOTMATCH : 0)
    files.reverse! if @option[:r]
    return @printer.print_detail_lines(files) if @option[:l]

    @printer.print_files_names(files)
  end
end

LS.new.exec
