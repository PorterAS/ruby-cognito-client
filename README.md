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

## Signup

Only `email` and `password` attributes are required.
Any custom attributes can be also provided, but make sure that they are defined in Cognito.
In the following example `name` is a custom attributes.

``` ruby
> email = 'test@example.com'
> password = 'password'
> name = 'me'

> Cognito::Container['operations.signup'].call(email: email, password: password, name: name)
# => Right(#<Cognito::Session cognito_id="...">)
```

## Adding user to group

To add a user to a group you need to have `cognito_id` (can be taken from `signup/signin` responses).
Make sure that provided group is defined in Cognito.

``` ruby
> Cognito::Container['operations.add_to_group'].call(cognito_id: "...", group: 'beta-testers')
# => Right(Cognito::VOID)
```

## Signup

To confirm pending user you need to pass `email` and a `code` from the email:

``` ruby
> Cognito::Container['operations.configm_signup'].call(email: email, code: 'code-from-the-email')
# => Right(Cognito::VOID)
```

## Signin

Just an `email` and a `password`:

``` ruby
> result = Cognito::Container['operations.signin'].call(email: email, password: password)
# => Right(#<Cognito::Session access_token="...", id_token="...", refresh_token="...", cognito_id="...">)
> result.success?
# => true
> session = result.value
# => #<Cognito::Session access_token="...", id_token="...", refresh_token="...", cognito_id="...">
> session.active?
# => true
> session.access_token.value
# => "..."
> session.id_token.value
# => "..."
> session.refresh_token.value
# => "..."
> session.cognito_id
# => "..."
```

## Retreiving current user data

Session is required to get current user data.
You can build it by specifying `access_token`, `id_token`, `refresh_token` and `cognito_id`
(or by passing return value of the `signin` operation).

``` ruby
> Cognito::Container['operations.me'].call(active_session)
# => Right(session: <same session>, user: { ...user data with groups info/custom attributes... })
> Cognito::Container['operations.me'].call(session_with_expired_access_token)
# => Right(session: <refreshed session>, user: { ...user data with groups info/custom attributes... })
> Cognito::Container['operations.me'].call(session_with_expired_refresh_token)
# => Left(reason: :no_session)
> Cognito::Container['operations.me'].call(empty_session)
# => Left(reason: :no_session)
```

To generate an expired access token (for testing purposes) you can use the following helper method:

``` ruby
def expire_session(active_session)
  access_token = active_session.access_token.value
  payload, headers = JWT.decode(access_token, nil, false)
  rsa_private = OpenSSL::PKey::RSA.generate 2048
  rsa_public = rsa_private.public_key
  payload['exp'] = Time.now.to_i - 1_000_000
  expired_token = JWT.encode(payload, rsa_private, 'RS256')

  active_session.with(access_token: expired_token)
end
```

It uses a different RSA key, but it doesn't matter, the token is expired and that is the first
error that comes from the `jwt` gem.

## Updating a user

``` ruby
> Cognito::Container['operations.update'].call(session: session, user_attributes: { name: 'new-name' })
# => Right(<new session>)
```

When you update an email it's also required to verify it.

## Email verification

``` ruby
> Cognito::Container['operations.verify_email'].call(session: <session>, code: <code from the email>)
# => Right(<new session>)
```

## DI

All operations can (and should) be DI-ed by writing
``` ruby
class YourClass
  include Cognito::Import['operations.signup', ..other operations if needed..]

  def call
    signup.call(email: 'email', password: 'password').bind do |session|
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
