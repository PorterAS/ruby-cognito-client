# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ConfirmForgotPassword
      include ::Cognito::Import['aws_client', 'void']
      include Dry::Monads::Either::Mixin

      def call(email:, password:, code:)
        aws_client.confirm_forgot_password(
          email: email,
          password: password,
          code: code
        ).bind { Right(void) }
      end
    end
  end
end
