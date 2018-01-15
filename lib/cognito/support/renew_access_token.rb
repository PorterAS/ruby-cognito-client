# frozen_string_literal: true

require 'cognito/import'

module Cognito
  class RenewAccessToken
    include ::Cognito::Import['aws_client', 'config', 'support.secret_hash']
    include Dry::Monads::Result::Mixin

    def call(access_token:, refresh_token:)
      return Failure(reason: :no_access_token) unless access_token

      payload, _headers = JWT.decode(access_token, nil, false) # without verification
      username = payload['username']

      auth_parameters = {
        'USERNAME' => username,
        'SECRET_HASH' => secret_hash[username],
        'REFRESH_TOKEN' => refresh_token
      }

      aws_client.
        admin_initiate_auth(**params, auth_parameters: auth_parameters).
        bind { |response| Success(access_token: response.authentication_result.access_token) }
    end

    private

    def params
      {
        auth_flow: 'REFRESH_TOKEN',
        user_pool_id: config[:user_pool_id],
        client_id: config[:client_id]
      }
    end
  end
end
