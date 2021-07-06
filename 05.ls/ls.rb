#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = { a: false, l: false, r: false }
  opt = OptionParser.new
  opt.on('-a', 'show hidden files') { options[:a] = true }
  opt.on('-l', 'show details') { options[:l] = true }
  opt.on('-r', 'reverse the order') { options[:r] = true }

  opt.parse!(ARGV)
  files = if options[:a]
            Dir.glob('*', File::FNM_DOTMATCH, sort: true)
          else
            Dir.glob('*', sort: true)
          end

  files = files.reverse if options[:r]

  if options[:l]
    output_with_l_option(files)
  else
    output(files)
  end
end

def filetype(filemode)
  {
    '10' => '-',
    '04' => 'd'
  }[filemode]
end

def permission(filemode)
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[filemode]
end

def output_with_l_option(files)
  puts "total #{files.inject(0) { |total, file| total + File.stat(file).blocks }}"
  files.each do |file|
    fileinfo = File.stat(file)
    filemode = fileinfo.mode.to_s(8)
    print filetype(filemode[0, 2])
    print permission(filemode[3])
    print permission(filemode[4])
    print permission(filemode[5])
    print "#{permission(filemode[6])} "
    print "#{fileinfo.nlink} "
    print "#{Etc.getpwuid(fileinfo.uid).name} "
    print "#{Etc.getgrgid(fileinfo.gid).name} "
    print "#{fileinfo.size} "
    print "#{fileinfo.mtime.strftime('%b %e %R')} "
    print file
    puts
  end
end

def lined_up(files)
  line = if (files.size % 3).zero?
           files.size / 3
         else
           files.size / 3 + 1
         end

  lined_up_files = []
  files.each_slice(line) do |n|
    lined_up_files << n
  end

  max_size = lined_up_files.map(&:size).max
  lined_up_files.map! { |it| it.values_at(0...max_size) }
  lined_up_files
end

def output(files)
  lined_up_files = lined_up(files)

  width = files.max_by(&:size).size
  lined_up_files.transpose.each do |lined_up_file|
    lined_up_file.each do |n|
      print n.ljust(width + 3) unless n.nil?
    end
    puts
  end
end

main
