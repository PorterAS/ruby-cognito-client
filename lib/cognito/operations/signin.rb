# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Signin
      include ::Cognito::Import['aws_client']
      include Dry::Monads::Either::Mixin

      def call(email:, password:)
        aws_client.signin(email: email, password: password).bind do |response|
          auth = response.authentication_result

          session = ::Cognito::Session.new(
            access_token:  auth.access_token,
            id_token:      auth.id_token,
            refresh_token: auth.refresh_token
          )

          Right(session)
        end
      end
    end
  end
end
