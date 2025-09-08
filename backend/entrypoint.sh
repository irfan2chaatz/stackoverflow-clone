#!/bin/bash

# Wait for Postgres
echo "Waiting for Postgres..."
while ! pg_isready -h db -p 5432 -U postgres; do
  sleep 1
done

# Create DB and run migrations
mix ecto.create
mix ecto.migrate

# Start Phoenix server
mix phx.server
