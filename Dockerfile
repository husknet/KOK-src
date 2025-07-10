# Dockerfile
FROM node:18-bullseye-slim

# Install Chromium’s native deps
RUN apt-get update && apt-get install -y \
  ca-certificates fonts-liberation libnss3 libatk1.0-0 libatk-bridge2.0-0 \
  libcups2 libdrm2 libxkbcommon0 libxshmfence1 libxcomposite1 libxdamage1 \
  libgbm1 libxrandr2 libxtst6 libu2f-udev wget --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Tell Puppeteer to skip its own Chromium download
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /usr/src/app

# Install only from package.json
COPY package.json ./
RUN npm install --production

# Copy in your source & next.config.js
COPY . .

# Build your Next.js app (webpack externals in next.config.js will keep Puppeteer out of the bundle)
RUN npm run build

# Expose and start via NPM script (which is "next start -p $PORT")
ENV PORT ${PORT:-3000}
EXPOSE $PORT
CMD npm start
