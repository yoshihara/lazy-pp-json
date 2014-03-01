# -*- coding: utf-8 -*-

require "stringio"
require "lazy/pp/json"

module Lazy::PP
  class JSONTest < Test::Unit::TestCase
    def setup
      @original_stdout = $stdout.dup
      @stdout = StringIO.new
      $stdout = @stdout
    end

    class EmptyTest < self
      def test_array
        assert_lazy_json("[]\n", '[]')
      end

      def test_hash
        assert_lazy_json("{}\n", '{}')
      end
    end

    class ArrayTest < self
      def test_single
        assert_lazy_json("[1]\n", '[1]')
      end

      def test_short_double
        assert_lazy_json("[1, 2]\n", '[1, 2]')
      end

      def test_double
        assert_lazy_json(<<EXPECTED, '["first", "last"]')
[
  "first",
  "last"
]
EXPECTED
      end

      def test_include_array
        actual_string = '["first", ["first-first", "first-last"], "last"]'
        assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  [
    "first-first",
    "first-last"
  ],
  "last"
]
EXPECTED
      end

      def test_include_short_array
        actual_string = '["first", [1,2], "last"]'
        assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  [1, 2],
  "last"
]
EXPECTED
      end

      def test_include_array_including_array
        actual_string = <<ACTUAL
["first", ["first-first", ["first-first-first", "first-first-last"]], "last"]
ACTUAL
        assert_lazy_json(<<EXPECTED, actual_string)
[
  "first",
  [
    "first-first",
    [
      "first-first-first",
      "first-first-last"
    ]
  ],
  "last"
]
EXPECTED
      end

      def test_include_hash
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
    end

    class HashTest < self
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

    def teardown
      $stdout = @original_stdout
    end

    private

    def assert_lazy_json(expected, actual_string)
      actual = Lazy::PP::JSON.new(actual_string)
      pp(actual)
      assert_equal(expected, @stdout.string, @stdout.string)
    end
  end
end
