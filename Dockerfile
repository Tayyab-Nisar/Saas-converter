# Use official Node.js image
FROM node:18-slim

# Install system dependencies: Chromium for Puppeteer + LibreOffice for Word conversion
RUN apt-get update && apt-get install -y \
    chromium \
    libreoffice \
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

# Set working directory to backend
WORKDIR /app/backend

# Copy backend package.json and package-lock.json
COPY backend/package*.json ./

# Install Node.js dependencies
RUN npm install

# Copy backend source code
COPY backend/ ./

# Expose API port
EXPOSE 3001

# Start backend server
CMD ["node", "index.js"]
