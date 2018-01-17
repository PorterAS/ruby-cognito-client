# frozen_string_literal: true

module Cognito
  class Config
    def [](key)
      to_h[key]
    end

    def to_h
      @to_h ||= begin
        {
          region: ENV['AWS_REGION'],
          user_pool_id: ENV['AWS_COGNITO_USER_POOL_ID'],
          client_id: ENV['AWS_COGNITO_CLIENT_ID'],
          client_secret: ENV['AWS_COGNITO_CLIENT_SECRET']
        }
      end
    end
  end
end
