# frozen_string_literal: true

# SUMMARY
# try "exec, system, Backticks(`), IO#popen, Open3#popen3, Open4#popen4" in ruby
# test for "stdin, stdout, stderr and status(the command"s result)"
#
# GLOSSARY
# no output: can"t get the result from stdout, stderr
# no status: have no knowledge of the success or failure of the command 
#            from you ruby script.
#
# QUOTE
# http://tech.natemurray.com/2007/03/ruby-shell-commands.html

require 'open3'

# exec
# 1. no output, no status, will terminate the program
open_exec = false
if open_exec
  exec 'ls -l'
  puts 'exec finish' # don"t execute
end

# system
# 1. support status
# 2. no output
puts '[system]'
system 'which ruby'
puts "output: can't get output"
puts "status: #{$CHILD_STATUS.class}, #{$CHILD_STATUS.to_i}"
puts "\n"

# Backticks(`)
# 1. support stdout, status
# 2. no stderr
puts '[Backticks]'
puts '-> for stdout:'
today = `date`
puts "output: #{today}"
puts "status: #{$CHILD_STATUS.class}, #{$CHILD_STATUS.to_i}"
puts "\n"

# can"t get stderr
puts '-> for stderr:'
warning = `nocommand -e "123"`
puts "output: can't get stderr #{warning}"
puts "status: #{$CHILD_STATUS.class}, #{$CHILD_STATUS.to_i}"
puts "\n"

# IO#popen
# 1. support stdout
# 2. no stderr, no status
puts '[IO.popen]'
IO.popen('date') { |f|
  puts "output: #{f.gets}"
  puts "status: can't get status"
}
puts "\n"

# Open3#popen3
# support stdin, output
# no status
puts '[Open3#popen3]'
stdin, stdout, _stderr = Open3.popen3('dc')
stdin.puts(5)
stdin.puts(10)
stdin.puts('+')
stdin.puts('p')
puts "output: #{stdout.gets()}"
puts "status: can't get status"
puts "\n"

puts '-> for false:'
_stdin, _stdout, _stderr = Open3.popen3('false')
puts "status: #{$CHILD_STATUS.class}, #{$CHILD_STATUS.to_i}"
puts "\n"

open_open4 = false
if open_open4
  # Open4::popen4
  # support stdin, output, status
  require 'open4'

  puts '[Open4::popen4]'
  pid, _stdin, _stdout, _stderr = popen4 'false'
  _ignored, status = waitpid2 pid
  puts "status: #{status.to_i}"
end
