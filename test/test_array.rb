# -*- coding: utf-8 -*-

require "testutils"

module Lazy::PP
  class JSON::ArrayTest < Test::Unit::TestCase
    include Lazy::PP::JSON::TestUtils

    def test_empty
      assert_lazy_json("[]\n", '[]')
    end

    def test_single
      assert_lazy_json('["1"]' + "\n", '["1"]')
    end

    def test_short_double
      assert_lazy_json('["1", "2"]' + "\n", '["1", "2"]')
    end

    def test_double
      assert_lazy_json(<<EXPECTED, '["first", "last"]')
[
  "first",
  "last"
]
EXPECTED
    end

    def test_including_array
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

    def test_including_array_including_array
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
