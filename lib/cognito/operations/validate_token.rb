# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ValidateToken
      include ::Cognito::Import['support.validate_jwt', 'support.renew_access_token']
      include Dry::Monads::Result::Mixin

      def call(access_token:, refresh_token:)
        renew_if_invalid = validate_jwt.call(access_token).or do
          renew_access_token.call(access_token: access_token, refresh_token: refresh_token)
        end

        renew_if_invalid.bind { |new_access_token| Success(access_token: new_access_token) }
      end
    end
  end
end
