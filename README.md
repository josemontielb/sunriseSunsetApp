# ☀️ Sunrise & Sunset API — Backend

A Ruby on Rails backend application that serves sunrise, sunset, and golden hour data for a given location and date range. Designed to integrate seamlessly with a modern frontend (e.g., React) and powered by the [sunrisesunset.io](https://sunrisesunset.io) API.

---

## 📌 Features

* 🌍 Accepts location and date range queries
* 📦 Caches results in a PostgreSQL database for performance
* 🔁 Fetches and stores data from `https://api.sunrisesunset.io` if not cached
* 🕓 Calculates golden hour
* 📡 RESTful API (`GET /api/v1/sun_events`)
* 🔐 Handles invalid or unsupported locations gracefully

---

## 🛠️ Tech Stack

* **Ruby on Rails** — API backend
* **PostgreSQL** — Primary database
* **HTTParty** — External API client
* **dotenv-rails** — Manage environment variables
* **Rack CORS** — Handles CORS configuration for frontend access

---

## 📂 Project Structure

```bash
/app
  ├── controllers
  │   └── api/v1/sun_events_controller.rb
  ├── models
  │   └── sun_event.rb
  └── services
      └── sun_events/fetcher.rb
/config
  ├── routes.rb
  └── initializers
      └── cors.rb
/db
  └── migrate
```

---

## ⚙️ Setup Instructions

### 1. Clone the repository

```bash
git clone git@github.com:josemontielb/sunriseSunsetApp.git
cd sunriseSunsetApp
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Set environment variables

Create a `.env` file in the root directory:

```env
# PostgreSQL configuration (edit as needed)
DB_USERNAME=your_postgres_user
DB_PASSWORD=your_postgres_password
DB_HOST=localhost
```

### 4. Database Configuration

Your `config/database.yml` should look like this:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  host: <%= ENV.fetch("DB_HOST") { "localhost" } %>
  username: <%= ENV.fetch("DB_USERNAME") { "postgres" } %>
  password: <%= ENV.fetch("DB_PASSWORD") { "" } %>
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: sunrise_sunset_app_development

test:
  <<: *default
  database: sunrise_sunset_app_test

production:
  <<: *default
  database: sunrise_sunset_app_production
```

### 5. Set up and migrate DB

```bash
rails db:create db:migrate
```

### 6. Start the server

```bash
rails server
```

Your API will run at [http://localhost:3000](http://localhost:3000).

---

## 🧪 Sample API Request

```http
GET /api/v1/sun_events?location=Lisbon&start_date=2024-05-01&end_date=2024-05-03
```

### ✅ Expected Response

```json
[
  {
    "id": 1,
    "location": "Lisbon",
    "date": "2024-05-01",
    "sunrise_time": "2024-05-01T06:42:00Z",
    "sunset_time": "2024-05-01T20:20:00Z",
    "golden_hour": "2024-05-01T07:42:00Z"
  },
  ...
]
```

---

## 📌 Supported Locations

The backend supports a predefined list of cities with hardcoded coordinates:

* Lisbon
* Berlin
* New York
* London
* Tokyo
* Sydney
* Paris
* Buenos Aires
* Cairo
* Nairobi

If a user enters an unsupported location, the API responds with:

```json
{ "error": "Invalid location. Supported locations: ..." }
```

---

## 📚 API Logic

### `SunEvents::Fetcher.call(location, start_date, end_date)`

* If data for a given `location` and `date` exists → return it.
* Else → fetch from `sunrisesunset.io`, store it in the DB, and return it.
* Calculates golden hour as `sunrise + 1 hour`.

---