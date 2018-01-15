# Cognito::Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognito', github: 'PorterAS/ruby-cognito-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cognito

## Usage

``` ruby
email = 'test@example.com'
password = 'password'

# sign up
Cognito::Container['operations.sign_up'].call(email: email, password: password)
# => Success(Cognito::VOID)

# confirm sign up
Cognito::Container['operations.configm_sign_up'].call(email: email, code: 'code-from-the-email')
# => Success(Cognito::VOID)

# sign in
Cognito::Container['operations.sign_in'].call(email: email, password: password)
# => Success(access_token: 'token', refresh_token: 'token')

# validate token
Cognito::Container['operations.validate_token'].call(access_token: 'token', refresh_token: 'token')
# => Success(access_token: 'potentially-new-token')

# user data
Cognito::Container['operations.me'].call(access_token: 'token', refresh_token: 'token')
# => Success(user: #<Cognito::User ...>, access_token: 'potentially-new-token')
```

All operations can (and should) be DI-ed by writing
``` ruby
class YourClass
  include Cognito::Import['operations.validate_token', ..other operations if needed..]

  def call
    validate_token.call(payload).bind do |access_token:, refresh_token:|
      # ... your code ...
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake` to run the tests + lint.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.
All environment variables can be specified in `.env.development`.

## Testing

No tests for now.
