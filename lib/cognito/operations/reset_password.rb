# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ResetPassword
      include ::Cognito::Import['aws_client', 'void']
      include Dry::Monads::Either::Mixin

      def call(email:)
        aws_client.reset_password(email: email).bind { Right(void) }
      end
    end
  end
end
