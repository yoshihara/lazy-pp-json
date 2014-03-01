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
            q.text "\n#{indent}"
            first = true
            object.each do |key, value|
              q.text(",\n#{indent}") unless first

              q.pp key
              q.text ":"
              q.group(1) do
                q.breakable ""
                json = create_next_json(value)
                q.pp json
              end
              first = false
            end
            q.text "\n#{prev_indent}"
          end
        when Array
          prev_element = nil
          q.group(indent_width, "[", "]") do
            first = true
            newline_first = false
            object.each do |element|
              if first
                if element.to_s.size > MIN_CHARACTER_SIZE
                  q.text "\n#{indent}"
                  newline_first = true
                end
              else
                  q.text ", "
                if prev_element.to_s.size > MIN_CHARACTER_SIZE
                else
                  q.text ",\n#{indent}"
                end
              end

              element = create_next_json(element)
              q.pp element
              prev_element = element
              first = false
            end

            q.text "\n#{prev_indent}" if newline_first
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

      def create_next_json(value)
        return value if value.instance_of?(String)
        value = JSON.new(value.to_s.gsub("=>", ":"))
        value.indent_count = @indent_count + 1
        value
      end
    end
  end
end
