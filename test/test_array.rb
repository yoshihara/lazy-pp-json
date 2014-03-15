# -*- coding: utf-8 -*-

require "testutils"

module Lazy
  module PP
    class JSON
      class ArrayTest < Test::Unit::TestCase
        include Lazy::PP::JSON::TestUtils

        def test_empty
          assert_lazy_json("[]\n", '[]')
        end

        def test_numeric
         assert_lazy_json('[1]' + "\n", '[1]')
        end

        def test_short_single
          assert_lazy_json('["1"]' + "\n", '["1"]')
        end

        def test_long_single
          assert_lazy_json(<<EXPECTED, "[\"#{LONG_STRING}\"]")
[
  "#{LONG_STRING}"
]
EXPECTED
        end

        def test_short_double
          assert_lazy_json('["1", "2"]' + "\n", '["1", "2"]')
        end

        def test_long_double
          assert_lazy_json(<<EXPECTED, SPLITED_LONG_ARRAY_STRING)
[
  "#{SPLITED_LONG_ARRAY.first}",
  "#{SPLITED_LONG_ARRAY.last}"
]
EXPECTED
        end

        def test_including_short_array
          actual_string = '["first", ["1","2"], "last"]'
          assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  ["1", "2"],
  "last"
]
EXPECTED
        end

        def test_including_long_array
          actual_string = "[\"first\", #{SPLITED_LONG_ARRAY_STRING}, \"last\"]"
          assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  [
    "#{SPLITED_LONG_ARRAY.first}",
    "#{SPLITED_LONG_ARRAY.last}"
  ],
  "last"
]
EXPECTED
        end

        def test_including_array_including_short_array
          actual_string = <<ACTUAL
["first", ["first-first", ["first-first-first", "first-first-last"]], "last"]
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  [
    "first-first",
    ["first-first-first", "first-first-last"]
  ],
  "last"
]
EXPECTED
        end

        def test_including_array_including_long_array
          actual_string = <<ACTUAL
["first", ["first-first", #{SPLITED_LONG_ARRAY_STRING}, "first-last"], "last"]
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  [
    "first-first",
    [
      "#{SPLITED_LONG_ARRAY.first}",
      "#{SPLITED_LONG_ARRAY.last}"
    ],
    "first-last"
  ],
  "last"
]
EXPECTED
        end

        def test_including_hash
          actual_string = <<ACTUAL
["first", {"key":"value"}, "last"]
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  {
    "key":"value"
  },
  "last"
]
EXPECTED
        end

        def test_short_including_hash
          actual_string = <<ACTUAL
["a", {"key":"value"}, "b"]
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
[
  "a",
  {
    "key":"value"
  },
  "b"
]
EXPECTED
        end
      end
    end
  end
end
