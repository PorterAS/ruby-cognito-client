# frozen_string_literal: true

require 'cognito/import'

module Cognito
  class RefreshSession
    include Dry::Monads::Either::Mixin

    def call(session:, aws_client:, force: false)
      return Right(session) if session.active? && !force
      return Left(reason: :no_session) unless session.can_refresh?

      aws_client.refresh(cognito_id: session.cognito_id, refresh_token: session.refresh_token.value).bind do |response|
        auth = response.authentication_result

        fresh_session = session.with(
          access_token: auth.access_token,
          id_token:     auth.id_token
        )

        Right(fresh_session)
      end
    end
  end
end
