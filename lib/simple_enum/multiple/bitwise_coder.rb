# Frozen-String-Literal: true
# Encoding: utf-8

module SimpleEnum
  module Multiple
    class BitwiseCoder
      def self.load(_d, d = _d.to_i)
        return [] if d.zero?

        (0..Math.log2(d).floor).reject do |i|
          (d & (1 << i)).zero?
        end
      end

      def self.dump(array)
        array.map do |i|
          1 << i
        end.reduce(&:+)
      end
    end
  end
end
