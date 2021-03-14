# frozen_string_literal: true

require 'optparse'
require 'etc'

HORIZONTAL_DISP = 3

def main
  ls
  ls_with_l
end

def ls(a_command: false, r_command: false)
  files = a_command ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  vertical_disp = (files.size.to_f / HORIZONTAL_DISP).ceil
  disp_file_length = files.max_by(&:length).length + 1
  sorted_files = r_command ? files.sort.reverse : files.sort

  sorted_files.each_with_index do |_file, i|
    0.upto(HORIZONTAL_DISP - 1) do |count|
      file = sorted_files[i + vertical_disp * count]
      print file.ljust(disp_file_length) unless file.nil?
    end
    print "\n"
    break if i == (vertical_disp - 1)
  end
end

def ls_with_l(a_command: false, r_command: false)
  files = a_command ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  sorted_files = r_command ? files.sort.reverse : files.sort

  disp_files = sorted_files.map { |filename| File.new(filename) }
  max_file_size = calculate_max_file_size(disp_files)

  disp_files.each do |disp_file|
    u_permission, g_permission, o_permission = format('0%o', disp_file.stat.mode)[-3, 3].split(//)

    print "#{convert_filetype(disp_file.stat.ftype)}#{convert_permission(u_permission)}#{convert_permission(g_permission)}#{convert_permission(o_permission)}  "
    print "#{disp_file.stat.nlink} "
    print "#{Etc.getpwuid(disp_file.stat.uid).name}  #{Etc.getgrgid(disp_file.stat.gid).name}  "
    print "#{disp_file.stat.size.to_s.rjust(max_file_size.to_s.length)}  "
    print "#{disp_file.stat.mtime.strftime('%-m %-d %H:%M')} "
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

def calculate_max_file_size(files)
  filesizes = files.map { |file| file.stat.size }
  filesizes.max
end

main
