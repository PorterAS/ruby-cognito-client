# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class Me
      include ::Cognito::Import['refresh_session', 'aws_client']
      include Dry::Monads::Either::Mixin

      def call(session)
        refresh_session.call(session: session, aws_client: aws_client).bind do |fresh_session|
          Right(session: fresh_session, user: fresh_session.id_token.payload)
        end
      end
    end
  end
end
