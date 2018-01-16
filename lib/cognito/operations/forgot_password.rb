# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ForgotPassword
      include ::Cognito::Import['aws_client', 'void']
      include Dry::Monads::Either::Mixin

      def call(email:)
        aws_client.forgot_password(email: email).bind { Right(void) }
      end
    end
  end
end
