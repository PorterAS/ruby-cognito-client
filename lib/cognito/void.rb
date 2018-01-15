# frozen_string_literal: true

module Cognito
  class Void
    def inspect
      '#<Cognito::VOID>'
    end
  end

  VOID = Void.new.freeze
end
