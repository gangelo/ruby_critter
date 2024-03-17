# frozen_string_literal: true

module RubyCritter
  module Misc
    # Module to allow for easy comparison of objects.
    module Equatable
      def ==(other)
        return false unless other.is_a?(self.class)

        to_h == other.to_h
      end
      alias eql? ==
    end
  end
end
