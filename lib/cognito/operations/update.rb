# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Update
      include ::Cognito::Import['refresh_session', 'aws_client']
      include Dry::Monads::Either::Mixin

      def call(session:, user_attributes:)
        refresh_session.call(session: session, aws_client: aws_client).bind do |fresh_session|
          access_token = fresh_session.access_token.value

          aws_client.update(access_token: access_token, user_attributes: user_attributes).bind do |_response|
            refresh_session.call(session: fresh_session, aws_client: aws_client, force: true).bind do |updated_session|
              Right(updated_session)
            end
          end
        end
      end
    end
  end
end
