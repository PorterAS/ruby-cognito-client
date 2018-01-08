# frozen_string_literal: true

module Cognito
  class Container
    extend Dry::Container::Mixin

    register :config,     -> { Cognito.config }
    register :aws_client, -> { Cognito.client }
    register :jwks,       -> { Cognito.jwks }

    def self.callable(&block)
      ->(*args) {
        object = block.call
        object.call(*args)
      }
    end

    namespace :support do
      register :secret_hash,        callable { Cognito::SecretHash.new }
      register :validate_jwt,       callable { Cognito::ValidateJWT.new }
      register :renew_access_token, callable { Cognito::RenewAccessToken.new }
    end

    namespace :operations do
      register :signup,         callable { Cognito::Operations::Signup.new }
      register :confirm_signup, callable { Cognito::Operations::ConfirmSignup.new }
      register :signin,         callable { Cognito::Operations::Signin.new }
      register :validate_token, callable { Cognito::Operations::ValidateToken.new }
    end
  end

  Import = Dry::AutoInject(Container)
end

require 'cognito/support/secret_hash'
require 'cognito/support/validate_jwt'
require 'cognito/support/renew_access_token'

require 'cognito/operations/signup'
require 'cognito/operations/confirm_signup'
require 'cognito/operations/signin'
require 'cognito/operations/validate_token'
