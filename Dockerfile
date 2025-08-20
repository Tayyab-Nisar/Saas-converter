FROM node:18-slim

# Install Chromium and Puppeteer dependencies
RUN apt-get update && apt-get install -y \
  chromium \
  libgbm1 \
  libnss3 \
  libatk-bridge2.0-0 \
  libxss1 \
  libasound2 \
  libatk1.0-0 \
  libcups2 \
  libdrm2 \
  libxcomposite1 \
  libxrandr2 \
  libpango1.0-0 \
  libgtk-3-0 \
  libxdamage1 \
  libxfixes3 \
  libepoxy0 \
  ca-certificates \
  fonts-liberation \
  libnspr4 \
  libx11-xcb1 \
  libxtst6 \
  xdg-utils \
  wget \
  --no-install-recommends && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Puppeteer uses system Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Main working directory
WORKDIR /app

# Copy dependency files (from root of project)
COPY package*.json /app/

# Install Node.js dependencies in /app/node_modules
RUN npm install

# Copy the rest of the project
COPY . /app/

# ---- Fix: symlink node_modules so backend can access them ----
RUN ln -s /app/node_modules /app/backend/node_modules

# Set working directory to backend
WORKDIR /app/backend

# Expose backend API port
EXPOSE 3001

# Start backend
CMD ["node", "index.js"]
