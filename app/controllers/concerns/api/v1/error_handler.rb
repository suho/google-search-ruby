# frozen_string_literal: true

module API
  module V1
    module ErrorHandler
      extend ActiveSupport::Concern

      private

      def build_errors(detail:, source: nil, meta: nil, code: nil)
        [
          {
            source: { parameter: source }.compact,
            detail: detail,
            code: code,
            meta: meta
          }.delete_if { |_, value| value.blank? }
        ]
      end
    end
  end
end
