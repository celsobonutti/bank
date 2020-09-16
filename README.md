# Bank

## Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Copy `config/dev.secret.exs.example` without `.example` and fill in your information
  * Do the same for `config/test.secret.exs.example`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `yarn install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser and check the app.

## Decisions

### Elixir

I chose Elixir as a back-end because of its well-known performance, scalability and great web framework (Phoenix).
I also think it's a very expressive language and, being a functional enthusiast, I could not think of a better language for this.

### React

Choosing React was a matter of preference: I'm used to it and like it very much. I think sometimes it _can_ be overkill, but overall
is my favorite front-end framework (or library, however you want to call it). TypeScript was a matter of adding a lit bit of type-safeness. My true desire was to use ReScript, but I thought it was better to stick with a more known language for this.

### Authentication

I used `phoenix-gen-auth` lib, which is created by the creators of Phoenix (and Elixir) and is based on production feedback from them. I also preferred to stick to a server-side rendering for authentication, which I think is more safe. The app itself (once you login), however, is an SPA.

### Styling

I decided to go with SASS + BEM, which I'm comfortable with and think is a good way to structure stylesheets. Although I think solutions like `styled-components` and `emotion` are great, I think generating styles at runtime is unnecessary when you can build them beforehand. I've thought about using TailwindCSS, but I think BEM is enough for a project of this size.

## UI Libs

I decided to go with Reakit, which is a very barebones UI lib focused more in implementing good a11y than styling itself, so I could take this part for granted and focus on the logic and visual parts.

## Tests

Back-end tests can be run with `mix test` in the root folder.
Front-end tests can be run with `yarn test` in the `assets` folder.

The Payment tests, however, were disabled due to boleto expiration.