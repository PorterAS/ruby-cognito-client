# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Signup
      include ::Cognito::Import['aws_client', 'config', 'support.secret_hash', 'void']
      include Dry::Monads::Either::Mixin

      def call(email:, password:, **)
        params = {
          client_id: config[:client_id],
          secret_hash: secret_hash[email],
          username: email,
          password: password
        }

        aws_client.sign_up(params).bind { Right(void) }
      end
    end
  end
end
