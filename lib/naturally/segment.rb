# frozen_string_literal: true

module Naturally
  # An entity which can be compared to other like elements for
  # sorting. It's an object representing
  # a value which implements the {Comparable} interface which can
  # convert itself to an array.
  class Segment
    include Comparable

    DIGITS_THEN_ALPHA = /^(\p{Digit}+)(\p{Alpha}+)$/
    ALPHA_THEN_DIGITS = /^(\p{Alpha}+)(\p{Digit}+)$/
    DIGITS            = /^\p{Digit}+$/

    # @return [Array] the sort key for a single token, computed without
    #                 allocating a {Segment}.
    def self.to_array(token)
      if (m = DIGITS_THEN_ALPHA.match(token))
        [:int, m[1].to_i, m[2]]
      elsif (m = ALPHA_THEN_DIGITS.match(token))
        [:str, m[1], m[2].to_i]
      elsif DIGITS.match?(token)
        [:int, token.to_i]
      else
        [:str, token]
      end
    end

    def initialize(v)
      @val = v
      @array = Segment.to_array(v)
    end

    def <=>(other)
      to_array <=> other.to_array
    end

    # @return [Array] a representation of myself in array form
    #                 which enables me to be compared against
    #                 another instance for sorting.
    #                 The array is prepended with a symbol so
    #                 two arrays are always comparable.
    #
    # @example a simple number
    #   Segment.new('10').to_array #=> [:int, 10]
    #
    # @example a college course code
    #   Segment.new('MATH101').to_array #=> [:str, "MATH", 101]
    #
    # @example Section 633a of the U.S. Age Discrimination in Employment Act
    #   Segment.new('633a').to_array #=> [:int, 633, "a"]
    def to_array
      @array
    end
  end
end
