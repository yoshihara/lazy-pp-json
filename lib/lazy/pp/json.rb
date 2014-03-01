# -*- coding: utf-8 -*-

require "pp"
require "json"

module Lazy
  module PP
    class JSON < String
      INDENT_SIZE = 2
      INDENT = ' ' * INDENT_SIZE
      MIN_CHARACTER_SIZE = 2

      attr_accessor :indent_count

      def initialize(raw)
        super(raw)
        @indent_count = 1
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
            text_indent(q)
            first = true
            object.each do |key, value|
              unless first
                q.text(",")
                text_indent(q)
              end

              q.pp key
              q.text ":"
              if value.instance_of?(String)
                q.pp value
                first = false
                next
              elsif value.instance_of?(Array)
                text_indent(q)
              end

              q.group do
                q.breakable ""
                json = create_next_json(value)
                q.pp json
              end
              first = false
            end
            text_prev_indent(q)
          end

        when Array
          prev_element = nil
          q.group(indent_width, "[", "]") do
            first = true
            newline_first = false
            object.each do |element|
              if first
                if element.to_s.size > MIN_CHARACTER_SIZE
                  text_indent(q)
                  newline_first = true
                end
              else
                text_separator(q, prev_element)
              end

              element = create_next_json(element)
              q.pp element
              prev_element = element
              first = false
            end

            text_prev_indent(q) if newline_first
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

      def create_next_json(value)
        return value if value.instance_of?(String)
        value = JSON.new(value.to_s.gsub("=>", ":"))
        value.indent_count = @indent_count + 1
        value
      end

      def text_separator(q, element)
        q.text ","
        if element.to_s.size > MIN_CHARACTER_SIZE
          q.text "\n#{indent}"
        else
          q.text " "
        end
      end
    end
  end
end
