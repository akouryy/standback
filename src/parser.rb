module Standback
  class ParseError < StandardError
    def initialize parser, msg = "unknown error occured"
      super "parse error: #{msg} at #{parser.i} (around #{parser.code[parser.i - 5, 11].inspect})"
    end
  end

  class Parser
    attr_reader :code, :i

    def initialize code
      @code = code.freeze
      @i = 0
    end

    private def c
      @code[@i]
    end

    private def c!
      c.tap{ @i += 1 }
    end

    private def undo_c!
      @i -= 1
    end

    private def match regexp
      m = regexp.match @code, @i
      if m && m.begin(0) == @i
        @i += m[0].size
        m[0]
      end
    end

    def parse!
      @i = 0
      parse_body
    end

    private def parse_body
      [].tap do |ret|
        while t = parse_cmd?
          ret << t
        end
        parse_spaces
      end
    end

    private def parse_block
      parse_body.tap{ parse_slash }
    end

    private def parse_cmd?
      parse_spaces
      cmd = c!
      if ['/', nil].include? cmd
        undo_c!
        return
      end
      cmd_pos = i
      parse_slash
      cmd = cmd.to_sym
      case cmd.downcase
      when :c
        [cmd, parse_string, cmd_pos]
      when :d
        [cmd, parse_string, parse_block, cmd_pos]
      when :g
        [cmd, parse_regexp, parse_string, cmd_pos]
      when :m
        [cmd, parse_regexp, parse_block, parse_block, cmd_pos]
      when :q
        [cmd, cmd_pos]
      when :s
        [cmd, parse_regexp, parse_string, cmd_pos]
      when :t
        [cmd, parse_string, parse_string, cmd_pos]
      when :w
        [cmd, parse_regexp, parse_block, cmd_pos]
      else
        raise ParseError.new self, "unknown command #{c.inspect}"
      end
    end

    private def parse_string
      m = match %r{([^/\\]+|\\[/\\%])*}
      raise ParseError.new self unless m # never happens
      parse_slash
      m
    end

    private def parse_regexp
      m = match %r{([^/\\]+|\\.)*}
      raise ParseError.new self unless m # never happens
      parse_slash
      Regexp.new m
    end

    private def parse_slash
      raise ParseError.new self, "expected slash but found #{c.inspect}" if c != '/'
      c!
    end

    private def parse_spaces
      match /(?:\p{Space}++|#.++)*+/
    end

    def self.parse code
      new(code).parse!
    end
  end
end
