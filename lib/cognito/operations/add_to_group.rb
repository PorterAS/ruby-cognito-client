# frozen_string_literal: true

require 'cognito/import'

module Cognito
  module Operations
    class AddToGroup
      include ::Cognito::Import['aws_client', 'void']
      include Dry::Monads::Either::Mixin

      def call(cognito_id:, group:)
        aws_client.add_to_group(
          cognito_id: cognito_id,
          group: group
        ).bind { Right(void) }
      end
    end
  end
end
