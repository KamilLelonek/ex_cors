# ex_cors

[![Build Status](https://travis-ci.org/KamilLelonek/ex_cors.svg?branch=master)](https://travis-ci.org/KamilLelonek/ex_cors)

An Elixir Plug-based CORS middleware for Phoenix Framework.

## Installation

The package can be installed by adding `ex_cors` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_cors, "~> 0.2"},
    # ...
  ]
end
```

After you're done, run `mix deps.get` in your terminal to fetch and compile all dependencies.

## Usage

`ex_cors` is intended to work with `Phoenix.Enpoint`. The only thing you have to do in order to make it working is to modify `your_app/lib/your_app/web/endpoint.ex` as follows:

```elixir
defmodule YourApp.Endpoint do
  use Phoenix.Enpoint, otp_app: :your_app

  # ...
  plug ExCors.AllowCorsRequests
  plug YourApp.Router
  # ...
end
```
