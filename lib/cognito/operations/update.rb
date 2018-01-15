# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Signup
      include ::Cognito::Import['aws_client']
      include Dry::Monads::Either::Mixin

      def call(email:, password:, user_attributes: {})
        aws_client.signup(email: email, password: password, user_attributes: user_attributes).bind do |response|
          cognito_id = response.user_sub
          session = ::Cognito::Session.new(cognito_id: cognito_id)
          Right(session)
        end
      end
    end
  end
end
