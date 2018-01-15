# frozen_string_literal: true

module Cognito
  class Config < Hash
    DEFAULTS = {
      region: ENV['AWS_REGION'],
      user_pool_id: ENV['AWS_COGNITO_USER_POOL_ID'],
      client_id: ENV['AWS_COGNITO_CLIENT_ID'],
      client_secret: ENV['AWS_COGNITO_CLIENT_SECRET']
    }.freeze

    def self.new(hash = {})
      self[DEFAULTS.merge(hash)]
    end
  end
end
