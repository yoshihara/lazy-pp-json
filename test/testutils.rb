# -*- coding: utf-8 -*-

require "stringio"
require "lazy/pp/json"

module Lazy
  module PP
    class JSON
      module TestUtils
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
