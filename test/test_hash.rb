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

        def test_including_array
          actual_string = <<ACTUAL
{"key1":["first","second"], "key2":"value2"}
ACTUAL
          assert_lazy_json(<<EXPECTED, actual_string)
{
  "key1":
  [
    "first",
    "second"
  ],
  "key2":"value2"
}
EXPECTED
        end

        def test_including_short_array
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

        def test_including_hash
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
