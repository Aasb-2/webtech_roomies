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

## Roles

- **Visitor** (not signed in): can browse and search published listings, and view listing and property pages, including their reviews. Everything else requires an account.
- **Member** (the default role on sign up): can create and manage their own properties and listings, apply to other members' listings (except their own), see the applications on their own listings plus the ones they wrote, shortlist/reject/accept applications on their own listings, propose or cancel a visit as the host or the applicant, write a review after their own completed visit, delete their own reviews, and report a listing.
- **Moderator**: can see and edit/delete any property, listing, or review, and see every application — but cannot shortlist/reject/accept applications or manage visits, since those stay host/seeker actions. Moderators manage the neighborhood and amenity catalogs and resolve listing reports. There's no sign-up path to become a moderator; the role is only ever set via seed data or directly in the database.

## Seeded credentials

`bin/rails db:seed` creates one moderator and seven members, all sharing the same password, so you can sign in as any of them to walk through the permission table above:

| Role               | Name            | Email                              | Password     |
|--------------------|-----------------|-------------------------------------|---------------|
| Moderator           | Mora Delgado    | mora.moderator@roomies.test         | `Roomies123!` |
| Member (host)       | Ana Restrepo    | ana.host@roomies.test               | `Roomies123!` |
| Member (host)       | Carlos Jimenez  | carlos.host@roomies.test            | `Roomies123!` |
| Member (host)       | Lucia Pardo     | lucia.host@roomies.test             | `Roomies123!` |
| Member (seeker)     | Diego Torres    | diego.seeker@roomies.test           | `Roomies123!` |
| Member (seeker)     | Valentina Ruiz  | valentina.seeker@roomies.test       | `Roomies123!` |
| Member (seeker)     | Mateo Gomez     | mateo.seeker@roomies.test           | `Roomies123!` |
| Member (seeker)     | Sara Mendoza    | sara.seeker@roomies.test            | `Roomies123!` |

For example: sign in as `diego.seeker@roomies.test` to apply to a listing, sign out and sign in as that listing's host to shortlist/accept the application, then sign in as `mora.moderator@roomies.test` to resolve a report or manage the neighborhood/amenity catalogs.

## JSON API

Base path: `/api/v1`. Public, read-only, versioned, and returns no personal data — no host names, emails, or reviewer identities, only listing/property/neighborhood/amenity data.

### `GET /api/v1/listings`

Returns all **published** listings. All query params are optional filters, matching the web search page:

| Param              | Type                  | Description                                              |
|--------------------|------------------------|------------------------------------------------------------|
| `neighborhood_id`  | integer                | Only listings whose property is in this neighborhood      |
| `max_rent`         | number                 | Only listings with `monthly_rent` at or below this value  |
| `available_from`   | date (`YYYY-MM-DD`)    | Only listings available on or before this date             |
| `amenity_id`       | integer                | Only listings whose property has this amenity              |

Example:
```bash
curl "http://localhost:3000/api/v1/listings?max_rent=900&neighborhood_id=1"
```

Response — `200 OK`:
```json
{
  "listings": [
    {
      "id": 2,
      "monthly_rent": 950.0,
      "deposit": 950.0,
      "available_date": "2026-11-01",
      "minimum_stay": 6,
      "furnished": true,
      "private_bathroom": false,
      "state": "published",
      "description": "Bright room with a shared rooftop terrace...",
      "house_rules": "No smoking indoors. Quiet hours after 10pm.",
      "created_at": "2026-10-22T21:07:37.468Z",
      "property": {
        "property_type": "apartment",
        "bedrooms": 3,
        "bathrooms": 2,
        "shared_spaces": "Living room, kitchen, rooftop terrace",
        "neighborhood": "Chapinero",
        "amenities": ["WiFi", "Laundry", "Elevator"],
        "average_rating": "4.0"
      },
      "photo_urls": []
    }
  ],
  "meta": { "count": 1 }
}
```

### `GET /api/v1/listings/:id`

Returns a single published listing, same object shape as one entry above (no `listings`/`meta` wrapper).

- `200 OK` — the listing exists and is published.
- `404 Not Found` — the id doesn't exist, or exists but isn't published. Draft, withdrawn, reserved, and rented listings are never exposed by id, same as they're excluded from the index. Body: `{"error": "Listing not found"}`.

## Notes for assignment 4

- **Authentication:** real accounts via Rails 8's built-in session-based authentication — sign up, sign in/out, password reset by email (delivered through Active Job), and a profile page (name, email, phone, bio). The Assignment 3 user switcher is gone entirely; the current user is whoever is signed in. Visitors (signed out) keep full access to the public part of the app: the landing page, search, listing pages, property pages, and reviews.
- **Authorization:** every model has a Pundit policy, enforced in controllers rather than relying on hidden buttons — see Roles above for what each one can do. The host's inbox and the seeker's sent-applications list are both built from a Pundit policy scope, and an application is no longer reachable by guessing its id in the URL.
- **Notification email:** a host receives an email (via Active Job/Solid Queue) whenever someone applies to one of their listings.
- **Photo uploads:** unchanged from Assignment 3 — a listing's photos must be JPEG, PNG, or WebP, and 5MB or less per file.
- `db:seed` still populates a full sample dataset — neighborhoods, amenities, properties, listings across every lifecycle state, applications/visits/reviews exercising the accept/withdraw rules, and two listing reports — now with real, known login credentials for every seeded user (see above).