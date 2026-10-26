# Project: Roomies

Team members:
Agustín Álvarez

## Prerequisites

Install these before setting up the project:

- **Ruby 4.0.6** (or compatible with Rails 8.1) — check with `ruby -v`
- **Rails 8.1.3.1** — check with `rails -v`
- **Node 26.1.0** and **Yarn** — check with `node -v` and `yarn -v`
- **PostgreSQL**, running locally, with a role that can create databases

## Setup

Clone the repository, then from its root, run the following in order:

```bash
bundle install
yarn install
bin/rails db:create
bin/rails active_storage:install
bin/rails action_text:install
bin/rails db:migrate
bin/rails db:seed
```

## Running the application

```bash
bin/dev
```

## Notes on this assignment (Assignment 3)

- **Photo uploads:** a listing's photographs must be JPEG, PNG, or WebP, and **5MB or less per file**. Anything else is rejected with a validation error on the listing form.
- **Acting as a user:** there's still no authentication. Use the user switcher in the top navigation bar to choose which user performs each action — that user becomes the author (host or seeker) of whatever you do next.
- `db:seed` populates a full set of sample data: neighborhoods, amenities, properties, listings in every lifecycle state (draft, published, reserved, rented, withdrawn), and applications/visits/reviews that exercise the accept/withdraw business rules.