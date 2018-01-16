# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class VerifyEmail
      include ::Cognito::Import['refresh_session', 'aws_client']
      include Dry::Monads::Either::Mixin

      def call(session:, code:)
        refresh_session.call(session: session, aws_client: aws_client).bind do |fresh_session|
          access_token = fresh_session.access_token.value

          aws_client.verify_email(access_token: access_token, code: code).bind do |_response|
            refresh_session.call(session: fresh_session, aws_client: aws_client, force: true).bind do |updated_session|
              Right(updated_session)
            end
          end
        end
      end
    end
  end
end
