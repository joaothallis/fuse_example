# Fuse Example

It's a simple example of how to use the [fuse](https://github.com/jlouis/fuse)
Erlang library using `Tesla.Middleware.Fuse` to create a circuit breaker.

## Running

Terminal 1:

```bash
elixir server.exs
```

Terminal 2:

```bash
elixir fuse.exs
```
