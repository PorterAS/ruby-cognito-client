# frozen_string_literal: true

module Cognito
  class MonadClient
    include Dry::Monads::Result::Mixin

    def initialize(aws)
      @aws = aws
    end

    METHODS_TO_WRAP = %i[
      confirm_sign_up
      admin_initiate_auth
      sign_up
      admin_initiate_auth
    ].freeze

    METHODS_TO_WRAP.each do |method_name|
      define_method(method_name) do |params|
        begin
          response = @aws.public_send(method_name, params)
          Success(response)
        rescue Aws::CognitoIdentityProvider::Errors::ServiceError => e
          Left(error: e.message)
        end
      end
    end
  end
end
