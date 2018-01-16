# frozen_string_literal: true

module Cognito
  class Session
    attr_reader :access_token, :id_token, :refresh_token, :cognito_id

    def initialize(access_token: nil, id_token: nil, refresh_token: nil, cognito_id: nil)
      @access_token  = ::Cognito::AccessToken.new(access_token)
      @id_token      = ::Cognito::IdToken.new(id_token)
      @refresh_token = ::Cognito::RefreshToken.new(refresh_token)

      @cognito_id    = @access_token.cognito_id || cognito_id

      freeze
    end

    def can_refresh?
      [refresh_token, cognito_id].none?(&:empty?)
    end

    def active?
      [access_token, id_token].all?(&:valid?) && !refresh_token.empty? && !cognito_id.empty?
    end

    def to_h
      {
        access_token: access_token.value,
        id_token:     id_token.value
      }
    end

    EMPTY = new.freeze

    def with(access_token: nil, id_token: nil, refresh_token: nil, cognito_id: nil)
      self.class.new(
        access_token:  access_token  || @access_token.value,
        id_token:      id_token      || @id_token.value,
        refresh_token: refresh_token || @refresh_token.value,
        cognito_id:    cognito_id    || @cognito_id
      )
    end
  end
end
