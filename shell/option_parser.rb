# frozen_string_literal: true

# SUMMARY
# 1. option arguments
#    bool -> opts.on('-v', '--[no-]verbose', 'Run verbosely'), --no-verbose 
#            for false
#     string -> opts.on('-n', '--name=NAME', 'Name to say hello to')
#     specific format -> require 'optparse/time', parser.on('-t', '--time
#                        [TIME]', Time, 'Begin execution at given time')

# 2. required arguments
#    parser.on('-r', '--required LIB',
#             'Require the LIBRARY before executing your script') 
# 3. aurguments to object
#    op.on('--user ID', User), User is a object
# 4. arguments to Hash
#    OptionParser.new.parse!(into: Hash)

# TIPS
# ARGV, is a array of input arguments
# %w[foo, bar] is shortcut for ['foo', 'bar']
# extension.sub!(/\A\.?(?=.)/, '.'), '/\A\.?(?=.)/', get dot's(or just the begin)
# index at the begin of the String.

# REF
# https://ruby-doc.org/stdlib-2.4.2/libdoc/optparse/rdoc/OptionParser.html

# MISSION

# Usage: option_parser.rb [options]
# Specific options:
#   -m, --model [model]  the file data's format (json, xlsx)
#   -f, --file  [file]   the file path.

# Common options:
#   -h, --help                     Show this message
#     --version                    Show version
require 'optparse'

#
# FileParser
#
class FileParser
  # TIPS: VERSION is a constant.
  VERSION = '1.0.0'
  # MODELS is a constant argument, so use freeze;
  MODELS = %w[json xlsx].freeze

  def initialize
    @model = nil
    @file_path = nil
  end

  def parse(args)
    op = option_parser
    op.parse!(args)
    puts "get mode: #{@model} path: #{@file_path}"
  end

  def option_parser
    OptionParser.new do |parser|
      parser.banner = 'Usage: ruby option_parser.rb [options]'
      add_specific_options(parser)
      add_custom_options(parser)
    end
  end

  def add_specific_options(parser)
    # TIPS: parser.separator is error
    parser.separator ''
    parser.separator 'Specific options:'

    parser.on('-m', '--model model', MODELS, 
              "the file data format (#{MODELS})") do |model|
      @model = model
    end
    parser.on('-f', '--file file', 'the file path.') do |file|
      @file_path = file
    end
  end

  def add_custom_options(parser)
    parser.separator ''
    parser.separator 'Common options:'

    parser.on_tail('-h', '--help', 'show help') do
      puts parser
    end

    parser.on_tail('-v', '--version', 'show version') do
      puts "version: #{VERSION}"
    end
  end
end

file_parser = FileParser.new
file_parser.parse(ARGV)
