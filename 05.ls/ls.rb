# frozen_string_literal: true

require 'optparse'
require 'etc'

NUM_OF_HORIZONTAL_DISP = 3

def main
  options = ARGV.getopts('a', 'r', 'l')
  file_names = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_file_names = options['r'] ? file_names.sort.reverse : file_names.sort
  if options['l']
    ls_with_l(sorted_file_names)
  else
    ls(sorted_file_names)
  end
end

def ls(file_names)
  num_of_vertical_disp = (file_names.size.to_f / NUM_OF_HORIZONTAL_DISP).ceil
  disp_file_name_length = file_names.max_by(&:length).length + 1

  sliced_file_names = file_names.each_slice(num_of_vertical_disp)

  matrixed_file_names = sliced_file_names.map do |array|
    if sliced_file_names.first.size != array.size
      (sliced_file_names.first.size - array.size).times do
        array.push('')
      end
    end
    array
  end

  transposed_file_names = matrixed_file_names.transpose
  transposed_file_names.each do |file_name_array|
    file_name_array.each do |file_name|
      print file_name.ljust(disp_file_name_length)
    end
    print "\n"
  end
end

def ls_with_l(file_names)
  disp_files = file_names.map { |file_name| File.new(file_name) }
  max_file_size = disp_files.map { |file| file.stat.size }.max
  max_file_nlink = disp_files.map { |file| file.stat.nlink }.max
  total_file_blocks = disp_files.map { |file| file.stat.blocks }.sum

  puts "total #{total_file_blocks}"
  disp_files.each do |disp_file|
    u_permission, g_permission, o_permission = format('0%o', disp_file.stat.mode)[-3, 3].split(//)

    print "#{convert_filetype(disp_file.stat.ftype)}#{convert_permission(u_permission)}#{convert_permission(g_permission)}#{convert_permission(o_permission)}  "
    print "#{disp_file.stat.nlink.to_s.rjust(max_file_nlink.to_s.length)} "
    print "#{Etc.getpwuid(disp_file.stat.uid).name}  #{Etc.getgrgid(disp_file.stat.gid).name}  "
    print "#{disp_file.stat.size.to_s.rjust(max_file_size.to_s.length)} "
    print "#{disp_file.stat.mtime.strftime('%_m %_d %H:%M')} "
    print disp_file.path
    print "\n"
  end
end

def convert_filetype(filetype)
  {
    file: '-',
    directory: 'd',
    characterSpecial: 'c',
    blockSpecial: 'b',
    fifo: 'f',
    link: 'l',
    socket: 's'
  }[filetype.to_sym]
end

def convert_permission(permission)
  {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x',
    '0' => '---'
  }[permission]
end

main
