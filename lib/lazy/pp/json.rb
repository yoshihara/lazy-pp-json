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

              first = false

              if value.instance_of?(String)
                q.pp value
                next
              end

              text_indent(q) if value.instance_of?(Array)

              q.group do
                q.breakable ""
                json = create_next_json(value)
                q.pp json
              end
            end

            text_prev_indent(q)
          end

        when Array
          q.group(indent_width, "[", "]") do
            first = true
            newline_separator = false
            object.each do |element|

              if first
                if element.to_s.size > MIN_CHARACTER_SIZE
                  text_indent(q)
                  newline_separator = true
                end
              else
                text_separator(q, newline_separator)
              end

              element = create_next_json(element)
              q.pp element
              first = false
            end

            text_prev_indent(q) if newline_separator
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
        JSON.new(value.to_s.gsub("=>", ":"), @indent_count + 1)
      end

      def text_separator(q, newline_separator)
        q.text ","
        if newline_separator
          text_indent(q)
        else
          q.text " "
        end
      end
    end
  end
end
