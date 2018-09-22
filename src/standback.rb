require_relative 'parser'
require_relative 'runner'

f = File.read ARGV.shift
puts Standback::Runner.run Standback::Parser::parse(f), gets(nil) || ''
