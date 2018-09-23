require_relative 'parser'
require_relative 'runner'

f = File.read ARGV.shift
$DEBUG = true if ARGV.delete('-d') || ENV['DEBUG'] || ENV['debug'] || f =~ /^\#@DEBUG/
print Standback::Runner.run Standback::Parser::parse(f), gets(nil) || ''
