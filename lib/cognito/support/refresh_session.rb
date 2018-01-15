# frozen_string_literal: true

require 'cognito/import'

module Cognito
  class RefreshSession
    include Dry::Monads::Either::Mixin

    def call(session:, aws_client:)
      if session.active?
        Right(session)
      elsif session.can_refresh?
        aws_client.refresh(cognito_id: session.cognito_id, refresh_token: session.refresh_token.value).bind do |response|
          fresh_session = session.with(
            access_token: response.authentication_result.access_token,
            id_token:     response.authentication_result.id_token
          )
          Right(fresh_session)
        end
      else
        Left(reason: :no_session)
      end
    end
  end
end
