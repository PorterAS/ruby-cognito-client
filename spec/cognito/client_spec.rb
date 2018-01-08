# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cognito::Client do
  it 'has a version number' do
    expect(Cognito::Client::VERSION).not_to be nil
  end
end
