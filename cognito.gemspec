
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cognito/version'

Gem::Specification.new do |spec|
  spec.name          = 'cognito'
  spec.version       = Cognito::VERSION
  spec.authors       = ['Ilya Bylich']
  spec.email         = ['ibylich@gmail.com']

  spec.summary       = 'Porter client for Amazon cognito.'
  spec.description   = 'A shared client for an amazon cognito. Used by auth-server and BE.'
  spec.homepage      = "https://github.com/PorterAS/ruby-cognito-client"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'dry-auto_inject'
  spec.add_dependency 'dry-container'
  spec.add_dependency 'dry-monads'
  spec.add_dependency 'dry-transaction'

  spec.add_dependency 'aws-sdk-cognitoidentityprovider'
  spec.add_dependency 'json-jwt'
  spec.add_dependency 'jwt'
end
