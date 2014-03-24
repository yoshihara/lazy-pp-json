# -*- coding: utf-8 -*-

require "stringio"
require "lazy/pp/json"

module Lazy
  module PP
    class JSON
      module TestUtils

        LONG_STRING_LENGTH = Lazy::PP::JSON::MAX_CHARACTER_SIZE + 2
        LONG_STRING = "a" * LONG_STRING_LENGTH
        SPLITED_LONG_ARRAY = [
          LONG_STRING[0..LONG_STRING_LENGTH/2-1],
          LONG_STRING[LONG_STRING_LENGTH/2..-1]
        ]

        SPLITED_LONG_ARRAY_STRING = SPLITED_LONG_ARRAY.inspect

        private

        def assert_lazy_json(expected, actual_string)
          actual = Lazy::PP::JSON.new(actual_string)
          output = actual.pretty_inspect
          assert_equal(expected, output, output)
        end
      end
    end
  end
end
