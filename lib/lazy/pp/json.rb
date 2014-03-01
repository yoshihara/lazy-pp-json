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
      end

      def pretty_print(q)
        begin
          object = ::JSON.parse(self)
        rescue
          q.text self
          return
        end

        if object.empty?
          q.pp object
          return
        end

        case object
        when Hash
          q.group(indent_width, "{", "}") do
            first = true
            object.each do |key, value|
              q.text(",") unless first

              text_indent(q)

              text_key(q, key)

              first = false

              text_value(q, value)
            end

            text_prev_indent(q)
          end

        when Array
          q.group(indent_width, "[", "]") do
            first = true
            object.each do |element|

              if first
                first = false
                if element.to_s.size > MIN_CHARACTER_SIZE
                  text_indent(q)
                  @newline_separator = true
                end
              else
                text_separator(q)
              end

              text_element(q, element)
            end

            text_prev_indent(q) if @newline_separator
          end
        end
      end

      def pretty_pring_circle(q)
        q.text(empty? ? "" : "{...}")
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

      def text_indent(q)
        q.text "\n#{indent}"
      end

      def text_prev_indent(q)
        q.text "\n#{prev_indent}"
      end

      def text_key(q, key)
        q.pp key
        q.text ":"
      end

      def text_value(q, value)
        if value.instance_of?(String)
          q.pp value
          return
        end

        text_indent(q) if value.instance_of?(Array)

        q.breakable ""
        text_element(q, value)
      end

      def text_element(q, element)
        element = create_next_json(element)
        q.pp element
      end

      def create_next_json(value)
        return value if value.instance_of?(String)
        JSON.new(value.to_s.gsub("=>", ":"), @indent_count + 1)
      end

      def text_separator(q)
        q.text ","
        if @newline_separator
          text_indent(q)
        else
          q.text " "
        end
      end
    end
  end
end
