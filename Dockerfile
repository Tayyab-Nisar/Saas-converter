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

# Set Puppeteer to use system Chromium
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Main working directory
WORKDIR /app

# Copy dependency files
COPY package*.json /app/

# Install Node.js dependencies
RUN npm install

# Copy the rest of the app
COPY . /app/

# Set backend working directory for running
WORKDIR /app/backend

# Expose API port
EXPOSE 3001

# Start server
CMD ["node", "index.js"]
