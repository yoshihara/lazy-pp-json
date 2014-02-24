# -*- coding: utf-8 -*-

require "stringio"
require "pp"
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
        assert_lazy_json("[]", "[]")
      end

      def test_hash
        assert_lazy_json("{}", "{}")
      end
    end

    def teardown
      $stdout = @original_stdout
    end

    private

    def assert_lazy_json(expected, actual_string)
      actual = Lazy::PP::JSON.new(actual_string)
      assert_equal(expected, pp(actual))
    end
  end
end
