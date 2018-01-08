# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Signup
      include ::Cognito::Import['aws_client', 'config', 'support.secret_hash']
      include Dry::Monads::Either::Mixin

      def call(email:, password:, **)
        aws_client.sign_up(
          client_id: config[:client_id],
          secret_hash: secret_hash[email],
          username: email,
          password: password
        ).bind { Right(success: true) }
      end
    end
  end
end
