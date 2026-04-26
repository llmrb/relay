# Relay architecture

Relay is a production-style, self-hostable LLM environment built on
[`llm.rb`](https://github.com/llmrb/llm.rb#readme). This document
covers the internal structure of the app for developers who want to
study, extend, or fork it.

## Overview

The architecture is intentionally simple. HTMX keeps the client light,
while server-rendered HTML keeps the application comfortable for
Ruby-focused developers. Background work is handled with Sidekiq, and
development processes are coordinated by Relay's task monitor.

Some important notes:

- The app boots from `app/init.rb`, which sets up the database,
  autoloading, and application initialization.
- `.env` is loaded automatically during boot when present.
- HTTP routing is handled by Roda, with templates rendered from
  `app/views` and static assets served from `public/`.
- Webpack builds the JavaScript and CSS assets from `app/assets`.
- `bundle exec rake dev:start` runs Relay's local development stack.

## Layout

The codebase is organized by responsibility:

- `app/concerns` contains reusable modules shared across routes, pages,
  and views
- `app/init` contains boot and framework setup
- `app/hooks` contains reusable request hooks
- `app/pages` contains full-page renderers
- `app/tools` contains tools
- `app/prompts` contains the system prompt
- `app/models` contains Sequel models
- `app/routes` contains route classes and WebSocket handlers
- `app/views` contains HTML templates and partials
- `app/workers` contains Sidekiq workers
- `db/` contains database configuration and migrations
- `tasks/` contains rake tasks for development, assets, and database
  work
- `lib/relay` contains support code like the task monitor

## Routes

A route is a class that inherits from `Relay::Routes::Base` and
implements `call`. `Base` delegates missing methods to the current Roda
instance, so route classes can use helpers like `view`, `partial`,
`request`, `response`, `session`, and `params`.

Routes also expose `r` as a small alias for `request`, which mirrors the
way Roda route blocks commonly refer to the request object:

```ruby
# app/routes/some_route.rb
module Relay::Routes
  class SomeRoute < Base
    def call
      r.redirect("/some-other-route")
    end
  end
end

# app/init/router.rb
r.on "some-route" do
  r.is do
    SomeRoute.new(self).call
  end
end
```

## Pages

A page is a class that inherits from `Relay::Pages::Base` and renders a
full page from `app/views/pages`. Like routes, pages delegate missing
methods to the current Roda instance, but they are intended for page
rendering rather than request actions:

```ruby
# app/pages/chat.rb
module Relay::Pages
  class Chat < Base
    prepend Relay::Hooks::RequireUser

    def call
      response["content-type"] = "text/html"
      page("chat", title: "Relay")
    end
  end
end

# app/init/router.rb
r.root do
  Pages::Chat.new(self).call
end
```

## Hooks

A hook is an ordinary Ruby module, usually stored under `app/hooks`,
that uses `prepend` to act as a hook for page and route objects. Hooks
implement `call` and control request flow similarly to a before filter:
they decide whether to let the request proceed by calling `super`, or
halt the request by returning or redirecting instead.

Hooks are named as verbs that describe the behavior they enforce, such
as `RequireUser`.

Each hook typically defines `call`, performs its setup or guard logic,
and then calls `super` to continue to the next prepended hook or, once
no hooks remain, the underlying page or route:

```ruby
module Relay::Hooks
  module RequireUser
    def call
      @user = Relay::Models::User[session["user_id"]]
      @user.nil? ? r.redirect("/sign-in") : super
    end
  end
end

module Relay::Pages
  class Chat < Base
    prepend Relay::Hooks::RequireUser

    def call
      page("chat", title: "Relay")
    end
  end
end
```

## State

Relay includes session support through Roda's session plugin. This is
useful for lightweight per-user state such as the current provider and
model, which can be rendered directly in views and updated through
normal route handlers.

For shared in-process state, Relay exposes `Relay.cache`, which is
backed by `Relay::Cache::InMemoryCache`. This is useful for small,
ephemeral caches such as model lists that can be reused across routes
without treating them as persistent data.

## Development

Relay includes a test suite built with `rack-test` and `test-unit` from
the Ruby standard library. The tests follow the patterns established in
the codebase and focus on HTTP route behavior.

### Setup

Install test dependencies:

```bash
bundle install
```

Run the full test suite:

```bash
rake test
```

### Test structure

- `test/setup.rb` contains the base test setup with Rack::Test
  integration
- `test/routes/` contains route-specific tests

Tests are automatically discovered from files matching
`test/**/*_test.rb`.
