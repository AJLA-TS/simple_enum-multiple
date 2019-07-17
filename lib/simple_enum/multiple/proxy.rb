# Frozen-String-Literal: true
# Encoding: utf-8

module SimpleEnum
  module Multiple
    class Proxy
      include Enumerable
      attr_reader :accessor
      attr_reader :origin

      def initialize(origin, accessor)
        @accessor = accessor
        @origin = origin
      end

      def push(*keys)
        keys = accessor.filter_keys(keys)
        origin.push(
          *accessor.fetch_values(
            keys
          )
        ).uniq!

        self
      end

      def delete(key)
        origin.delete(
          accessor.enum.value(
            key
          )
        ) && key
      end

      def proxy
        accessor.fetch_keys(
          origin
        )
      end

      alias_method :<<, :push
      alias_method :to_a, :proxy
      delegate :inspect, :to_s, :==, :each,
        :join, :empty?, to: :proxy
    end
  end
end
