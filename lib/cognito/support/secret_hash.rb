# frozen_string_literal: true

require 'cognito/import'
require 'base64'
require 'openssl'

module Cognito
  class SecretHash
    include ::Cognito::Import['config']

    def call(username)
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha256'),
          config[:client_secret],
          username + config[:client_id]
        )
      ).strip
    end
  end
end
