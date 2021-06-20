require 'optparse'
require 'etc'

class Command
  def initialize(l_option: false, a_option: false, r_option: false)
    file_paths = a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    sorted_file_paths = r_option ? file_paths.sort.reverse : file_paths.sort
    @files = sorted_file_paths.map do |file_path|
      LsFile.new(file_path, File::Stat.new(file_path))
    end
    @formatter = l_option ? LognFormatter.new : ShortFormatter.new
  end

  def output
    @formatter.print_file_list(@files)
  end
end

class LsFile
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
  def print_file_list(files); end
end

class ShortFormatter < Formatter
  def print_file_list(files); end
end

p Command.new
