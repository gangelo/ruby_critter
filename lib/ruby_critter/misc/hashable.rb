# frozen_string_literal: true

module RubyCritter
  module Misc
    # Module to allow for returning an object hash.
    module Hashable
      def to_h
        raise NotImplementedError, 'to_h must be implemented in the including module or class'
      end

      def hash
        to_h.values.map(&:hash).hash
      end
    end
  end
end
