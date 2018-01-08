# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class ConfirmSignup
      include ::Cognito::Import['aws_client', 'config', 'support.secret_hash']
      include Dry::Monads::Either::Mixin

      def call(email:, code:)
        params = {
          client_id: config[:client_id],
          secret_hash: secret_hash[email],
          username: email,
          confirmation_code: code,
          force_alias_creation: false
        }

        aws_client.confirm_sign_up(params).bind { Right(success: true) }
      end
    end
  end
end
