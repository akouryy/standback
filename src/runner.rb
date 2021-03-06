require_relative 'lib'

module Standback
  class Runner
    def initialize stmts, input
      @stmts = stmts
      @input = input.freeze
    end

    def run
      @a = @input.dup
      @A = "".dup
      @fns = Lib.dup
      @matches = []

      run_body @stmts
      @A
    end

    private def run_body body
      body.each{|s| run_cmd s }
    end

    private def run_cmd s
      dbg :begin, s if $DEBUG
      up = s[0] =~ /^[A-Z]$/
      a1 = up ? @A : @a
      a2 = up ? @a : @A

      case s[0].downcase
      when :c
        f = @fns[s[1]]
        @matches, ms = [], @matches
        @a, @A = a1, a2
        case f
        when Array
          run_body f
        when Proc
          f.call @a, @A
        else
          raise "undefined function #{s[1].inspect}" unless f
        end
        @matches = ms
        @a, @A = a2, a1 if up
      when :d
        @fns[s[1]] = s[2]
      when :g
        a1.gsub!(s[1]){ replace s[2], Regexp.last_match }
      when :m
        if m = a1.match(s[1])
          @matches << m
          r = run_body s[2]
          @matches.pop
          r
        else
          run_body s[3]
        end
      when :q
        if a1.empty?
          exit
        else
          abort a1
        end
      when :s
        a1.sub!(s[1]){ replace s[2], Regexp.last_match }
      when :t
        a1.tr! s[1], s[2]
      when :w
        while m = a1.match(s[1])
          @matches << m
          run_body s[2]
          @matches.pop
        end
      else
        raise "what is #{s.inspect}?"
      end.tap{|x| dbg 'end  ', s if $DEBUG }
    end

    private def replace str, match
      @matches << match
      r = str.gsub %r{
        (?<var> (?<percents>%+) (?<varname>[0-9&`'+])) |
        (?<escape>\\ (?<escaped>.))
      }x do
        my_match = Regexp.last_match
        if my_match[:var]
          m = @matches[-my_match[:percents].size]
          case v = my_match[:varname]
          when ?0..?9
            m[v.to_i]
          when ?&
            m[0]
          when ?+
            m[-1]
          when ?`
            m.pre_match
          when ?'
            m.post_match
          end
        elsif my_match[:escape]
          my_match[:escaped]
        end
      end
      @matches.pop
      r
    end

    private def dbg status, s
      $stderr.puts "#{status} #{s[0]}(#{s[-1]}): a1=#{@a.inspect} a2=#{@A.inspect}"
    end

    def self.run stmts, input
      new(stmts, input).run
    end
  end
end
