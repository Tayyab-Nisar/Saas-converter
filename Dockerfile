FROM node:18-slim

# Install Puppeteer dependencies
RUN apt-get update && apt-get install -y \
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
  libasound2 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libxss1 \
  libxtst6 \
  xdg-utils \
  wget \
  --no-install-recommends && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy files
COPY package.json ./
RUN npm install
COPY . .

# Expose port
EXPOSE 3001

# Start the app
CMD ["node", "index.js"]
