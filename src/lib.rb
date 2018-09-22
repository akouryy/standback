module Standback
  NUM_REGEXP = /^-?\d+(\.\d+)?/

  Lib = {
    'chr' => proc do |a1, a2|
      a1.sub! NUM_REGEXP do |m|
        m.to_i.chr
      end
    end,
    'ord' => proc do |a1, a2|
      a1.sub! /^./ do |m|
        m.ord
      end
    end,
    '+' => proc do |a1, a2|
      a1.sub! NUM_REGEXP do |m|
        m.to_f + a2[NUM_REGEXP].to_f
      end
    end,
    '\/' => proc do |a1, a2|
      a1.sub! NUM_REGEXP do |m|
        m.to_f / a2[NUM_REGEXP].to_f
      end
    end,
  }.freeze
end
