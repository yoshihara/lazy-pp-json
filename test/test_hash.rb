# -*- coding: utf-8 -*-

require "testutils"

module Lazy
  module PP
    class JSON
      class HashTest < Test::Unit::TestCase
        include Lazy::PP::JSON::TestUtils

        def test_empty
          assert_lazy_json("{}\n", '{}')
        end

        def test_numeric
          assert_lazy_json(<<EXPECTED, '{"key":2}')
{
  "key":2
}
EXPECTED
        end

        def test_single
          assert_lazy_json(<<EXPECTED, '{"key":"value"}')
{
  "key":"value"
}
EXPECTED
        end

        def test_double
          assert_lazy_json(<<EXPECTED, '{"key1":"value1", "key2":"value2"}')
{
  "key1":"value1",
  "key2":"value2"
}
EXPECTED
        end

        def test_different_key_length
          assert_lazy_json(<<EXPECTED, '{"key-first":"value1", "key-second":"value2"}')
{
  "key-first" :"value1",
  "key-second":"value2"
}
EXPECTED
        end

        def test_short_array_as_value
          actual_string = <<ACTUAL
{"key1":["1","2"], "key2":"value2"}
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
{
  "key1":
  ["1", "2"],
  "key2":"value2"
}
EXPECTED
        end

        def test_long_array_as_value
          actual_string = <<ACTUAL
{"key1":#{SPLITED_LONG_ARRAY_STRING}, "key2":"value2"}
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
{
  "key1":
  [
    "#{SPLITED_LONG_ARRAY.first}",
    "#{SPLITED_LONG_ARRAY.last}"
  ],
  "key2":"value2"
}
EXPECTED
        end

        def test_including_short_hash
          actual_string = <<ACTUAL
{"key1":{"1":"2","3rd":"4th"}, "key2":"value2"}
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
{
  "key1":
  {
    "1"  :"2",
    "3rd":"4th"
  },
  "key2":"value2"
}
EXPECTED
        end

        def test_including_long_hash
          actual_string = <<ACTUAL
{"key1":{"key1-1":"value1-1","key1-2":"value1-2"}, "key2":"value2"}
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
{
  "key1":
  {
    "key1-1":"value1-1",
    "key1-2":"value1-2"
  },
  "key2":"value2"
}
EXPECTED
        end
      end
    end
  end
end
