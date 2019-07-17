# Frozen-String-Literal: true
# Encoding: utf-8

require 'simple_enum/multiple/bitwise_coder'
require 'simple_enum/multiple/accessors'

module SimpleEnum
  module Multiple
    class BitwiseAccessors < Accessors
      def init(klass)
        source = self.source
        klass.class_eval do
          serialize source, SimpleEnum::Multiple::BitwiseCoder
        end
      end

      def scope(collection, value)
        column = Arel::Nodes::Group.new(collection.arel_table[source]).to_sql
        collection.where(
          '? >> ? & 1 = 1', column, value
        )
      end
    end
  end
end
