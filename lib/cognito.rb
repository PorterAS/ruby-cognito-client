# frozen_string_literal: true

require 'cognito/version'

require 'dry-container'
require 'dry-auto_inject'
require 'dry-monads'
require 'aws-sdk-cognitoidentityprovider'
require 'jwt'
require 'json/jwt'

require 'open-uri'

require 'cognito/config'
require 'cognito/import'
require 'cognito/aws_client'
require 'cognito/void'

module Cognito
end

require 'cognito/jwks'
require 'cognito/token'
require 'cognito/session'
