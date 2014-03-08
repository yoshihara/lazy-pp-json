# -*- coding: utf-8 -*-

require "stringio"
require "lazy/pp/json"

module Lazy
  module PP
    class JSON
      module TestUtils

        # 52 chars
        LONG_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        SPLITED_LONG_ARRAY = [
          LONG_STRING[0..25],
          LONG_STRING[26..51]
        ]

        SPLITED_LONG_ARRAY_STRING = <<ACTUAL
["#{LONG_STRING[0..25]}", "#{LONG_STRING[26..51]}"]
ACTUAL

        def setup
          @original_stdout = $stdout.dup
          @stdout = StringIO.new
          $stdout = @stdout
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
  end
end
