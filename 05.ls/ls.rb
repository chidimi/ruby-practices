# frozen_string_literal: true

require 'optparse'

HORIZONTAL_DISP = 3

def main
  ls
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

main
