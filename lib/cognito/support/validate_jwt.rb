# frozen_string_literal: true

require 'cognito/import'

module Cognito
  class ValidateJWT
    include ::Cognito::Import['jwks']
    include Dry::Monads::Result::Mixin

    def call(token)
      jwks.decode(token)

      Success(token)
    rescue JWT::DecodeError => e
      Failure(reason: e.message)
    end
  end
end
