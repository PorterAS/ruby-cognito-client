# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ConfirmResetPassword
      include ::Cognito::Import['aws_client', 'void']
      include Dry::Monads::Either::Mixin

      def call(email:, password:, code:)
        aws_client.confirm_reset_password(
          email: email,
          password: password,
          code: code
        ).bind { Right(void) }
      end
    end
  end
end
