module ReverseMarkdown
  module Converters
    class Tr < Base
      def convert(node)
        content = treat_children(node).rstrip
        result  = "|#{content}\n"
        table_header_row?(node) ? result + underline_for(node) : result
      end

      def table_header_row?(node)
        node.element_children.all? { |child| child.name.to_sym == :th } ||
        node.parent.children.index(node) == 1
      end

      def underline_for(node)
        '| ' + (['---'] * node.element_children.size).join(' | ') + " |\n"
      end
    end

    register :tr, Tr.new
  end
end
