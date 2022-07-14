# frozen_string_literal: true

require 'etc'
require 'optparse'

TYPES_OF_FILE = {
  '10' => 'p',
  '20' => 'c',
  '40' => 'd',
  '60' => 'b',
  '100' => '-',
  '120' => 'l',
  '140' => 's'
}.freeze
PERMISSION_CODE = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze
class LS
  def initialize
    opt = OptionParser.new
    @option = {}

    opt.on('-a') { |v| @option[:a] = v }
    opt.on('-r') { |v| @option[:r] = v }
    opt.on('-l') { |v| @option[:l] = v }
    opt.parse!(ARGV)
  end

  def exec
    files = Dir.glob('*', @option[:a] ? File::FNM_DOTMATCH : 0)
    files.reverse! if @option[:r]
    return files.map { |file| print_file_detail(file) } if @option[:l]
  
    columns = 3
    number_of_rows = (files.length % columns).zero? ? files.length / columns : files.length / columns + 1
    tab_files = files.each_slice(number_of_rows).to_a
    number_of_rows.times do |i|
      lines = tab_files.map { |file| file[i]&.slice(0, 15)&.ljust(20) unless file[i].nil? }.compact
      puts lines.join('')
    end
  end

  def print_file_permissions(file)
    file_stat = File.lstat(file).mode.to_s(8)
    permission_number = file_stat[-3..-1]
    type_of_file = TYPES_OF_FILE[(file_stat[0..-4])]
    permission_code = permission_number.chars.map do |c|
      PERMISSION_CODE[c.to_i]
    end.join('')
    type_of_file + permission_code
  end

  def print_file_detail(file)
    str = '%5s  %5s  %5s  %5s  %5s  %5s  %5s'
    file_stat = File.lstat(file)
    file_detail = [print_file_permissions(file),
                   file_stat.nlink.to_s, user_name(file_stat.uid),
                   group_name(file_stat.gid),
                   file_stat.size.to_s,
                   format_created_time(file_stat.mtime),
                   file]
    puts(str % file_detail).inspect
  end

  def user_name(uid)
    Etc.getpwuid(uid).name
  end

  def group_name(gid)
    Etc.getgrgid(gid).name
  end

  def format_created_time(created_time)
    created_time.strftime('%m月 %d %H:%M').to_s
  end
end

LS.new.exec
