# Dockerfile
FROM node:18-bullseye-slim

# Install Chromium’s native deps
RUN apt-get update && apt-get install -y \
  ca-certificates fonts-liberation libnss3 libatk1.0-0 libatk-bridge2.0-0 \
  libcups2 libdrm2 libxkbcommon0 libxshmfence1 libxcomposite1 libxdamage1 \
  libgbm1 libxrandr2 libxtst6 libu2f-udev wget --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Skip Puppeteer’s download (we’ll use @sparticuz/chromium)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /usr/src/app
COPY package.json  ./
RUN npm ci
COPY . .
RUN npm run build

ENV PORT ${PORT:-3000}
EXPOSE $PORT
CMD ["npm", "start", "-p", "$PORT"]
