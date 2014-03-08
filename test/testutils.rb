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
      end
    end
  end
end
