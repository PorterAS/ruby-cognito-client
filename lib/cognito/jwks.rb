# frozen_string_literal: true

module Cognito
  class JWK
    attr_reader :jwk, :rsa_public

    def initialize(jwk)
      @jwk = jwk
      @rsa_public = JSON::JWK.new(jwk).to_key
    end

    def id
      @jwk['kid']
    end
  end

  class JWKS
    include Cognito::Import['config']

    def keys
      @keys ||= begin
        url = "https://cognito-idp.#{config[:region]}.amazonaws.com/#{config[:user_pool_id]}/.well-known/jwks.json"
        JSON.parse(open(url).read)['keys'].map { |key| JWK.new(key) }
      end
    end

    def decode(token)
      _payload, headers = JWT.decode(token, nil, false) # without verification
      used_kid = headers['kid']
      used_key = keys.detect { |key| key.id == used_kid }

      raise JWT::VerificationError, 'Signature verification raised' unless used_key

      JWT.decode(token, used_key.rsa_public, true, algorithm: 'RS256')
    end
  end
end
