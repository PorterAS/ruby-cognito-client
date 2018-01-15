# frozen_string_literal: true

module Cognito
  class PlainToken
    attr_reader :value

    def initialize(value = nil)
      @value = value

      freeze
    end

    def empty?
      value.nil?
    end

    def valid?
      !empty?
    end

    def inspect
      value = @value.nil? ? nil : @value.first(5) + '...'
      %(#<#{self.class} value=#{value.inspect}>)
    end
  end

  class JwtToken
    include ::Cognito::Import['jwks']
    attr_reader :value, :payload

    def initialize(value = nil, **kwrest)
      super(**kwrest)

      @payload = Payload.new(value, jwks: jwks)
      @value = value

      freeze
    end

    def empty?
      value.nil?
    end

    def invalid?
      payload.empty?
    end

    def valid?
      !empty? && !invalid?
    end

    def cognito_id
      payload['sub']
    end

    def inspect
      value = @value.nil? ? nil : (@value.first(5) + '...')
      %(#<#{self.class} value=#{value.inspect}>)
    end

    class Payload < Hash
      def self.new(jwt, jwks:)
        return self[] if jwt.nil?

        payload, _headers = jwks.decode(jwt)
        self[payload]
      rescue ::JWT::DecodeError
        self[]
      end
    end
  end

  class AccessToken < JwtToken
  end

  class IdToken < JwtToken
  end

  class RefreshToken < PlainToken
  end
end
