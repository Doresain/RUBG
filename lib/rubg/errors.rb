# frozen_string_literal: true

module RUBG
  module Errors
    class Base < StandardError; end

    class Overlimit < Base
      def message
        @message || 'Too Many Requests'
      end
    end
  end
end
