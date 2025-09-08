# Use Debian-based Elixir image
FROM elixir:1.16.2

# Environment variables for Hex & Mix cache
ENV HEX_HTTP_TIMEOUT=600
ENV MIX_XDG_CACHE_HOME=/tmp/mix_cache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    git \
    curl \
    postgresql-client \
    tzdata \
    && mix local.hex --force \
    && mix local.rebar --force

# Set working directory
WORKDIR /app

# Copy backend environment variables
COPY .env .env

# Copy mix files first for caching deps
COPY mix.exs mix.lock ./
COPY config config

# Install Elixir dependencies
RUN mix deps.get --force
RUN mix deps.compile

# Copy the rest of the backend app
COPY . .

# Build assets (if using Phoenix + JS assets)
RUN if [ -d "assets" ]; then cd assets && npm install && npm run deploy; fi

# Compile Phoenix
RUN mix compile

# Expose port
EXPOSE 4000

# Start server
CMD ["mix", "phx.server"]
