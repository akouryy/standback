require_relative 'parser'
require_relative 'runner'

$DEBUG = true if ARGV.delete('-d') || ENV['DEBUG'] || ENV['debug']
f = File.read ARGV.shift
print Standback::Runner.run Standback::Parser::parse(f), gets(nil) || ''
