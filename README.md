# Cognito::Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognito', github: 'PorterAS/ruby-cognito-client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cognito-client

## Usage

``` ruby
email = 'test@example.com'
password = 'password'

# sign up
Cognito::Container['operations.sign_up'].call(email: email, password: password)
# => Success({ success: true })

# confirm sign up
Cognito::Container['operations.configm_sign_up'].call(email: email, code: 'code-from-the-email')
# => Success({ success: true })

# sign in
Cognito::Container['operations.sign_in'].call(email: email, password: password)
# => Success({ access_token: 'token', refresh_token: 'token' })

# validate token
Cognito::Container['operations.validate_token'].call(access_token: 'token', refresh_token: 'token')
# => Success({ access_token: 'new-token' })
```

All operations can (and should) be DI-ed by writing
``` ruby
class YourClass
  include Cognito::Import['operations.sign_in', ..other operations if needed..]

  def call
    sign_in.call(email: email, password: password)
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
