# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ConfirmSignup
      include ::Cognito::Import['aws_client', 'void']
      include Dry::Monads::Either::Mixin

      def call(email:, code:)
        aws_client.confirm_signup(
          email: email,
          code: code
        ).bind { Right(void) }
      end
    end
  end
end
