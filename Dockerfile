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

# Set the working directory to /app (this is where your code should live)
WORKDIR /app

# Copy package.json to the /app directory
COPY package.json /app/

# Install dependencies
RUN npm install

# Copy all project files to the container
COPY . /app/

# Expose the app port
EXPOSE 3001

# Set the correct working directory to where your application entry file (index.js) is located
WORKDIR /app/backend

# Start the app
CMD ["node", "index.js"]
