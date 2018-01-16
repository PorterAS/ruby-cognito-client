# frozen_string_literal: true

module Cognito
  class Container
    extend Dry::Container::Mixin

    register :config,     -> { Cognito::Config.new }
    register :aws_client, -> { Cognito::MonadAwsClient.new }
    register :jwks,       -> { Cognito::JWKS.new }
    register :void,       -> { Cognito::VOID }

    def self.callable(&block)
      ->(*args) {
        object = block.call
        object.call(*args)
      }
    end

    register :secret_hash,      callable { Cognito::SecretHash.new }
    register :refresh_session,  callable { Cognito::RefreshSession.new }

    namespace :operations do
      register :signup,         callable { Cognito::Operations::Signup.new }
      register :add_to_group,   callable { Cognito::Operations::AddToGroup.new }
      register :confirm_signup, callable { Cognito::Operations::ConfirmSignup.new }
      register :signin,         callable { Cognito::Operations::Signin.new }
      register :me,             callable { Cognito::Operations::Me.new }
      register :update,         callable { Cognito::Operations::Update.new }
      register :verify_email,   callable { Cognito::Operations::VerifyEmail.new }
    end
  end

  Import = Dry::AutoInject(Container)
end

require 'cognito/support/secret_hash'
require 'cognito/support/refresh_session'

require 'cognito/operations/signup'
require 'cognito/operations/add_to_group'
require 'cognito/operations/confirm_signup'
require 'cognito/operations/signin'
require 'cognito/operations/me'
require 'cognito/operations/update'
require 'cognito/operations/verify_email'
