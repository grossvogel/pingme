# Pingme

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Running multiple nodes

This app is designed to work across multiple nodes, which takes a bit of extra work to test locally. You can run as many copies of the app locally as you like, as long as they all have their own node name. E.g.
```
PORT=4000 iex --name zero@127.0.0.1 -S mix phx.server
PORT=4001 iex --name one@127.0.0.1 -S mix phx.server
PORT=4002 iex --name two@127.0.0.1 -S mix phx.server
...
```
