# frozen_string_literal: true

module Cognito
  class Void
    def inspect
      '#<Cognito::VOID>'
    end

    def to_json
      {}.to_json
    end
  end

  VOID = Void.new.freeze
end
