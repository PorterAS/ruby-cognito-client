# frozen_string_literal: true

require 'cognito/version'

require 'dry-container'
require 'dry-auto_inject'
require 'dry-monads'
require 'aws-sdk-cognitoidentityprovider'
require 'jwt'
require 'json/jwt'

require 'open-uri'

require 'cognito/import'
require 'cognito/aws_key'
require 'cognito/monad_client'
require 'cognito/void'

module Cognito
  def self.client
    @client ||= Cognito::MonadClient.new(
      Aws::CognitoIdentityProvider::Client.new(
        region: ENV['AWS_REGION']
      )
    )
  end

  def self.config
    {
      user_pool_id: ENV['AWS_COGNITO_USER_POOL_ID'],
      client_id: ENV['AWS_COGNITO_CLIENT_ID'],
      client_secret: ENV['AWS_COGNITO_CLIENT_SECRET']
    }
  end

  KEYS_URL = "https://cognito-idp.#{ENV['AWS_REGION']}.amazonaws.com/#{config[:user_pool_id]}/.well-known/jwks.json"

  def self.jwks
    @jwks ||= Cognito::AwsKeyChain.new(url: KEYS_URL)
  end
end
