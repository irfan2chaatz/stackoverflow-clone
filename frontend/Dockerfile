# frontend/Dockerfile
FROM node:20-bullseye

WORKDIR /app

# Copy package files first for caching dependencies
COPY package.json package-lock.json ./

RUN npm install

# Copy frontend source
COPY . .

# Build the Vite app (outputs to dist/)
RUN npm run build

# Install a lightweight server
RUN npm install -g serve

# Serve dist/ (not build/)
CMD ["serve", "-s", "dist", "-l", "5173"]

EXPOSE 5173
