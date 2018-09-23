require_relative 'parser'
require_relative 'runner'

$DEBUG = true if ARGV.delete '-d'
f = File.read ARGV.shift
print Standback::Runner.run Standback::Parser::parse(f), gets(nil) || ''
