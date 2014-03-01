# -*- coding: utf-8 -*-

require "pp"
require "json"

module Lazy
  module PP
    class JSON < String
      INDENT_SIZE = 2
      INDENT = ' ' * INDENT_SIZE
      MIN_CHARACTER_SIZE = 2

      def initialize(raw, indent_count=nil)
        super(raw)
        @indent_count = indent_count || 1
        @newline_separator = false
        @pretty_print = nil
      end

      def pretty_print(pretty_print)
        @pretty_print = pretty_print
        begin
          object = ::JSON.parse(self)
        rescue
          @pretty_print.text self
          return
        end

        if object.empty?
          @pretty_print.pp object
          return
        end

        case object
        when Hash
          @pretty_print.group(indent_width, "{", "}") do
            first = true
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
            first = true
            object.each do |element|

              if first
                first = false
                if element.to_s.size > MIN_CHARACTER_SIZE
                  text_indent
                  @newline_separator = true
                end
              else
                text_separator
              end

              text_element(element)
            end

            text_prev_indent if @newline_separator
          end
        end
      end

      def pretty_pring_circle(pretty_print)
        pretty_print.text(empty? ? "" : "{...}")
      end

      private

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
        @pretty_print.pp key
        @pretty_print.text ":"
      end

      def text_value(value)
        if value.instance_of?(String)
          @pretty_print.pp value
          return
        end

        text_indent if value.instance_of?(Array)

        @pretty_print.breakable ""
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
