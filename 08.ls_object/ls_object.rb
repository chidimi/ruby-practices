# frozen_string_literal: true

require 'optparse'
require 'etc'

class Command
  def initialize(a_option: false, l_option: false, r_option: false)
    file_paths = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_file_paths = r_option ? file_paths.sort.reverse : file_paths.sort
    files = sorted_file_paths.map do |file_path|
      LsFile.new(file_path, File::Stat.new(file_path))
    end
    @file_container = LsFileContainer.new(files)
    @formatter = l_option ? LongFormatter.new : ShortFormatter.new
  end

  def output
    @formatter.print_file_list(@file_container)
  end
end

class LsFileContainer
  attr_reader :files, :max_file_size, :max_file_nlink, :total_file_blocks, :disp_file_name_length

  def initialize(files)
    @files = files
    @max_file_size = files.map(&:size).max
    @max_file_nlink = files.map(&:nlink).max
    @total_file_blocks = files.map(&:blocks).sum
    @disp_file_name_length = files.map { |file| file.path.length }.max + 1
  end
end

class LsFile
  attr_reader :type, :permission, :nlink, :uid, :gid, :size, :mtime, :path, :blocks

  PERMISSION_TABLE = {
    '0' => '---',
    '1' => '-x-',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file_path, file_stat)
    @type = file_stat.directory? ? 'd' : '-'
    @permission = convert_permimmison(file_stat.mode)
    @nlink = file_stat.nlink
    @uid = Etc.getpwuid(file_stat.uid).name
    @gid = Etc.getgrgid(file_stat.gid).name
    @size = file_stat.size
    @mtime = file_stat.mtime.strftime('%_m %_d %H:%M')
    @path = file_path
    @blocks = file_stat.blocks
  end

  private

  def convert_permimmison(mode)
    digits = mode.to_s(8)[-3..-1]
    digits.gsub(/./, PERMISSION_TABLE)
  end
end

class Formatter
  def print_file_list(_files)
    raise '抽象メソッドが呼び出されました。'
  end
end

class LongFormatter < Formatter
  def print_file_list(file_container)
    puts "total #{file_container.total_file_blocks}"

    file_container.files.each do |file|
      print "#{file.type}#{file.permission}  "
      print "#{file.nlink.to_s.rjust(file_container.max_file_nlink.to_s.length)} "
      print "#{file.uid}  #{file.gid}  "
      print "#{file.size.to_s.rjust(file_container.max_file_size.to_s.length)} "
      print "#{file.mtime} "
      print file.path
      puts
    end
  end
end

class ShortFormatter < Formatter
  NUM_OF_HORIZONTAL_DISP = 3

  def print_file_list(file_container)
    num_of_vertical_disp = (file_container.files.size.to_f / NUM_OF_HORIZONTAL_DISP).ceil
    sliced_files = file_container.files.each_slice(num_of_vertical_disp)

    matrixed_files = sliced_files.map do |array|
      if sliced_files.first.size != array.size
        (sliced_files.first.size - array.size).times do
          array.push(nil)
        end
      end
      array
    end

    transposed_files = matrixed_files.transpose
    transposed_files.each do |file_array|
      file_array.each do |file|
        print file.path.ljust(file_container.disp_file_name_length) unless file.nil?
      end
      puts
    end
  end
end

options = ARGV.getopts('a', 'l', 'r')
command = Command.new(a_option: options['a'], l_option: options['l'], r_option: options['r'])
command.output
