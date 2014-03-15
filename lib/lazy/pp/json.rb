# -*- coding: utf-8 -*-

require "pp"
require "json"

module Lazy
  module PP
    class JSON < String
      INDENT_SIZE = 2
      INDENT = ' ' * INDENT_SIZE
      MAX_CHARACTER_SIZE = 40

      def initialize(raw, indent_count=nil)
        super(raw)
        @indent_count = indent_count || 1
        @newline_separator = false
        @key_max_length = 0
        @pretty_print = nil
      end

      def pretty_print(pretty_print)
        @pretty_print = pretty_print
        begin
          object = ::JSON.parse(self)
        rescue
          if self.kind_of?(Numeric) or self.kind_of?(String)
            @pretty_print.text self
            return
          else
            raise
          end
        end

        if object.empty?
          @pretty_print.pp object
          return
        end

        case object
        when Hash
          @pretty_print.group(indent_width, "{", "}") do
            first = true
            @key_max_length = object.keys.map(&:length).max
            object.each do |key, value|
              @pretty_print.text(",") unless first

              text_indent

              text_key(key)

              first = false

              text_value(value)
            end

            text_prev_indent
          end

        when Array
          @pretty_print.group(indent_width, "[", "]") do
            if separate_elements_with_newline?(object)
              @newline_separator = true
            end

            object.each.with_index do |element, i|
              if i.zero?
                text_indent if @newline_separator
              end

              text_element(element)
              text_separator if i < object.length-1
            end

            text_prev_indent if @newline_separator
          end
        end
      end

      def pretty_print_cycle(pretty_print)
        pretty_print.text(empty? ? "" : "{...}")
      end

      private

      def json_value_format?(object)
        object.instance_of?(Array) or object.instance_of?(Hash)
      end

      def separate_elements_with_newline?(object)
        return false unless object.instance_of?(Array)
        return true if object.any? {|element| json_value_format?(element) }

        array_length = object.map(&:to_s).join.size + indent_width
        array_length > MAX_CHARACTER_SIZE
      end

      def indent
        " " * indent_width
      end

      def prev_indent
        " " * prev_indent_width
      end

      def indent_width
        INDENT_SIZE * @indent_count
      end

      def prev_indent_width
        INDENT_SIZE * (@indent_count - 1)
      end

      def text_indent
        @pretty_print.text "\n#{indent}"
      end

      def text_prev_indent
        @pretty_print.text "\n#{prev_indent}"
      end

      def text_key(key)
        @pretty_print.text "\"#{key}\"".ljust(@key_max_length + 2)
        @pretty_print.text ":"
      end

      def text_value(value)
        if value.instance_of?(String)
          @pretty_print.pp value
          return
        end

        text_indent if json_value_format?(value)
        text_element(value)
      end

      def text_element(element)
        element = create_next_json(element)
        @pretty_print.pp element
      end

      def create_next_json(value)
        return value if value.instance_of?(String)
        JSON.new(value.to_s.gsub("=>", ":"), @indent_count + 1)
      end

      def text_separator
        @pretty_print.text ","
        if @newline_separator
          text_indent
        else
          @pretty_print.text " "
        end
      end
    end
  end
end
