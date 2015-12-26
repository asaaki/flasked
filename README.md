# Flasked

> _flasked - something (an elixir) bottled into a flask_

Flasked injects application environment configuration at runtime based on given ENV variables and a mapping.

This is pretty useful for applications following the [_12 factor app_](http://12factor.net/) principle stated by Heroku.

For the specific details see <http://12factor.net/config>.

Also in container environments like Docker this comes in quite handy when you're literally forced to use ENV vars for
configuration of your specific container at startup time.

```sh
# provide ENV var
MY_FLASKED_APP_FOO=this_is_foo iex -S mix
```

```elixir
# use the ENV var value in the app
iex(1)> Application.get_env(:my_flasked_app, :foo)
"this_is_foo"
```

## Rationale

OTP apps/releases are normally preconfigured and do not provide the tooling for runtime configuration out of the box.
At least it is quite difficult and involves a lot of customization of every app or release.

The Phoenix framework only provides to set the `PORT` via `ENV` variable, the rest still has to be hard-coded.

Fiddling with the release configuration to enable more variables to be set at runtime is quite cumbersome and not well
documented.

On the other hand, especially with containerization in mind, most of the environment specific configuration should be
done at runtime, meaning you should not hard-code any environment/stage/role based configuration.

I agree with separation of code and configuration, because configs are state, and the application artifacts should be
stateless.

There are similar projects like [Dotenv](https://github.com/avdi/dotenv_elixir), [Envy](https://github.com/BlakeWilliams/envy) and [ExConf](https://github.com/leakybucket/env_conf), but they don't go
far enough for what I wanted. Most of them tackle only a very low-level need or are useful in development only.

### Why no YAML or JSON for the mapping?

I'll just quote [José Valim](https://twitter.com/josevalim) here:

> Please avoid YAML in Elixir projects. It is unnecessarily complex, both in implementation and usage. Elixir already provides config files.
>
> —<https://twitter.com/josevalim/status/626131275150065665>

And `Code.eval_file("some/file.exs")` does the job just fine, really.

## Installation

```elixir
# mix.exs
def deps do
  [{:flasked, "~> 0.3"}]
end
```

## Usage

### Add flasked to `applications`

Make sure Flasked is in the `applications` list, preferably the very first one.
(If it is the first, you can even reconfigure the logger before startup.)

```elixir
def application do
  [
    applications: [:flasked],
    # ...
  ]
end
```

### Add mapping

Furthermore you need to set up the mapping file:

```elixir
# priv/flasked_env.exs
%{
  my_flasked_app: %{
    foo: {:flasked, :MY_FLASKED_APP_FOO},
    bar: {:flasked, :MY_FLASKED_APP_BAR, :integer},
    baz: [something: [nested: {:flasked, :MY_FLASKED_APP_BAZ, :dict}]]
  }
}
```

So the placeholder has to be always a tuple in the following form:

```elixir
{:flasked, :MY_FLASKED_APP_ENV_VAR_NAME} # defaults to string type
{:flasked, :MY_FLASKED_APP_ENV_VAR_NAME, :a_valid_type_atom}
```

### Update config

Extend/modify your `config/config.exs`:

```elixir
config :flasked,
  otp_app: :my_flasked_app,
  map_file: "priv/flasked_env.exs" # must match with real file relative to the app's root directory
```

### Run

Test and run your application:

```
MY_FLASKED_APP_FOO=some_foo_val \
MY_FLASKED_APP_BAR=42 \
MY_FLASKED_APP_BAZ=key:val,info=values_will_be_strings \
iex -S mix
```

In the console:

```elixir
Application.get_env(:my_flasked_app, :foo)
#=> "some_foo_val"
Application.get_env(:my_flasked_app, :bar)
#=> 42
Application.get_env(:my_flasked_app, :baz)
#=> [something: [nested: [key: "val", info: "values_will_be_strings"]]]
```

## The mapping file

This file is just a normal Elixir script file with a map as its content:

```elixir
# priv/flasked_env.exs
%{
  my_flasked_app: %{
    key: {:flasked, :MY_FLASKED_APP_KEY},
    another: {:flasked, :MY_FLASKED_APP_ANOTHER, :boolean},
    port: {:flasked, :MY_FLASKED_APP_PORT, :integer, 4000},
  },

  another_app: [can: "be a dict, too"],

  logger: %{
    furthermore: "they do not need to have ENV placeholders",
    but: "you can offload everything from config/*.exs here, if you really like to"
  }
}
```

The application will fail to start if a placeholder was specified but the ENV var could not be found, unless you
specify a default value.

### About defaults and development

Use defaults rarely and wisely. Be more explicit, even in development mode.

To avoid manually providing every single env var for development, see [wrapper_example/](wrapper_example/) for a
Makefile based setup. (Just copy `env.mk` and `Makefile` into your project, adjust values and run `make console`).

## ENV Var placeholders

```elixir
{:flasked, :MY_FLASKED_APP_KEY} # shortcut for string type without a default as fallback
{:flasked, :MY_FLASKED_APP_KEY, :boolean} # value type specified, no default given
{:flasked, :MY_FLASKED_APP_KEY, :integer, 1234} # value type and default specified
```

So the tuple must always have `:flasked` as first element, an atom matching the ENV var you want to read, and optionally
a type and a default. If you want to give a default you always need to specify the type, even for strings.

## Supported types

```
MY_FLASKED_APP_VAR=a_string_val
  {:flasked, MY_FLASKED_APP_VAR}
  => "a_string_val"

MY_FLASKED_APP_VAR=true
  {:flasked, MY_FLASKED_APP_VAR, :boolean}
  => true
  - valid values: TRUE, true, FALSE, false
  - any other value will always default to `false`

MY_FLASKED_APP_VAR=9
  {:flasked, MY_FLASKED_APP_VAR, :integer}
  => 9

MY_FLASKED_APP_VAR=3.1415
  {:flasked, MY_FLASKED_APP_VAR, :float}
  => 3.1415

MY_FLASKED_APP_VAR=list,of,strings
  {:flasked, MY_FLASKED_APP_VAR, :list}
  => ["list", "of", "strings"]

MY_FLASKED_APP_VAR=list,of,atoms
  {:flasked, MY_FLASKED_APP_VAR, :list_of_atoms}
  => [:list, :of, :atoms]

MY_FLASKED_APP_VAR=1,2,3
  {:flasked, MY_FLASKED_APP_VAR, :list_of_integers}
  => [1, 2, 3]

MY_FLASKED_APP_VAR=4.44,5.555,6.789
  {:flasked, MY_FLASKED_APP_VAR, :list_of_floats}
  => [4.44, 5.555, 6.789]

MY_FLASKED_APP_VAR=this:is,a:dictionary
  {:flasked, MY_FLASKED_APP_VAR, :dict}
  => [this: "is", a: "dictionary"]
```

More sophisticated types could be supported. You're welcome to contribute.

## Enjoy!
