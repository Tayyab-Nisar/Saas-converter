FROM node:18-slim

# Install Chromium dependencies
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

ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

WORKDIR /app/backend

# Copy package.json for backend
COPY backend/package*.json ./

# Install backend dependencies (includes multer)
RUN npm install

# Copy backend source code
COPY backend/ ./

EXPOSE 3001

CMD ["node", "index.js"]
