# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Signin
      include ::Cognito::Import['aws_client', 'config', 'support.secret_hash']
      include Dry::Monads::Either::Mixin

      def call(email:, password:)
        auth_parameters = {
          'USERNAME' => email,
          'PASSWORD' => password,
          'SECRET_HASH' => secret_hash[email]
        }

        aws_client.admin_initiate_auth(**params, auth_parameters: auth_parameters).bind do |response|
          access_token = response.authentication_result.access_token
          refresh_token = response.authentication_result.refresh_token

          Right(access_token: access_token, refresh_token: refresh_token)
        end
      end

      private

      def params
        {
          auth_flow: 'ADMIN_NO_SRP_AUTH',
          user_pool_id: config[:user_pool_id],
          client_id: config[:client_id]
        }
      end
    end
  end
end
