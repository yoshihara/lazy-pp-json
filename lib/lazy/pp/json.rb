# -*- coding: utf-8 -*-

require "pp"
require "json"

module Lazy
  module PP
    class JSON < String
      INDENT_SIZE = 2
      INDENT = ' ' * INDENT_SIZE

      attr_accessor :indent_count

      def initialize(raw)
        super(raw)
        @indent_count = 1
      end

      def pretty_print(q)
        begin
          object = ::JSON.parse(self)
        rescue
          if String === self
            q.text self
            return
          end
        end

        if object.empty?
          q.pp object
          return
        end

        case object
        when Hash
          q.group(indent_width, "{\n#{indent}", "\n#{prev_indent}}") do
            first = true
            object.each do |key, value|
              q.text(",\n#{indent}") unless first

              q.pp key
              q.text ":"
              q.group(1) do
                q.breakable ""
                if Hash === value or Array === value
                  value = JSON.new(value.to_s.gsub("=>", ":"))
                  value.indent_count = @indent_count + 1
                end
                q.pp value
              end
              first = false
            end
          end
        when Array
          prev_element = nil
          q.group(indent_width, "[") do
            first = true
            newline_first = false
            object.each do |element|
              if first
                if element.to_s.size > 2
                  q.text "\n#{indent}"
                  newline_first = true
                end
              else
                if prev_element.to_s.size < 2
                  q.text ", "
                else
                  q.text ",\n#{indent}"
                end
              end

              if Hash === element or Array === element
                element = JSON.new(element.to_s.gsub("=>", ":"))
                element.indent_count = @indent_count + 1
              end
              q.pp element
              prev_element = element
              first = false
            end

            q.text "\n#{prev_indent}" if newline_first
            q.text "]"
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
    end
  end
end
