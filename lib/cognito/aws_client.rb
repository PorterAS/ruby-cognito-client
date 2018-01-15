# frozen_string_literal: true

module Cognito
  class PlainAwsClient
    include ::Cognito::Import['config', 'secret_hash']
    include Dry::Monads::Either::Mixin

    def initialize(config:, secret_hash:, **options)
      options = options.merge(region: config[:region])
      @aws = Aws::CognitoIdentityProvider::Client.new(options)
      super(config: config, secret_hash: secret_hash)
    end

    def signup(email:, password:, user_attributes:)
      @aws.sign_up(
        client_id: config[:client_id],
        secret_hash: secret_hash[email],
        username: email,
        password: password,
        user_attributes: user_attributes.map { |name, value| { name: name, value: value } }
      )
    end

    def add_to_group(cognito_id:, group:)
      @aws.admin_add_user_to_group(
        user_pool_id: config[:user_pool_id],
        username: cognito_id,
        group_name: group
      )
    end

    def confirm_signup(email:, code:)
      @aws.confirm_sign_up(
        client_id: config[:client_id],
        secret_hash: secret_hash[email],
        username: email,
        confirmation_code: code,
        force_alias_creation: false
      )
    end

    def signin(email:, password:)
      @aws.admin_initiate_auth(
        auth_flow: 'ADMIN_NO_SRP_AUTH',
        user_pool_id: config[:user_pool_id],
        client_id: config[:client_id],
        auth_parameters: {
          'USERNAME' => email,
          'PASSWORD' => password,
          'SECRET_HASH' => secret_hash[email]
        }
      )
    end

    def refresh(cognito_id:, refresh_token:)
      @aws.admin_initiate_auth(
        auth_flow: 'REFRESH_TOKEN',
        user_pool_id: config[:user_pool_id],
        client_id: config[:client_id],
        auth_parameters: {
          'USERNAME' => cognito_id,
          'SECRET_HASH' => secret_hash[cognito_id],
          'REFRESH_TOKEN' => refresh_token
        }
      )
    end

    def update(access_token:, user_attributes:)
      @aws.update_user_attributes(
        user_attributes: user_attributes.map { |name, value| { name: name, value: value } },
        access_token: access_token
      )
    end
  end

  class MonadAwsClient < PlainAwsClient
    def self.eitherify(method_name)
      prepend(Module.new do
        define_method(method_name) do |params|
          begin
            response = super(params)
            Right(response)
          rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
            Left(error: e.message)
          end
        end
      end)
    end

    eitherify :signup
    eitherify :add_to_group
    eitherify :confirm_signup
    eitherify :signin
    eitherify :refresh
  end
end
