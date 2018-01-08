# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ValidateToken
      include ::Cognito::Import['support.validate_jwt', 'support.renew_access_token']
      include Dry::Monads::Result::Mixin

      TO_RESULT = ->(access_token) {
        Dry::Monads::Result::Success.new(success: true, access_token: access_token)
      }

      def call(access_token:, refresh_token:)
        validate_jwt.call(access_token).bind(TO_RESULT).or do
          renew_access_token.
            call(access_token: access_token, refresh_token: refresh_token).
            bind(TO_RESULT)
        end
      end
    end
  end
end
