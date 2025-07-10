/** @type {import('next').NextConfig} */
const nextConfig = {
  // Skip Next.js’ built-in App Router transpilation for these modules
  webpack(config, { isServer }) {
    if (isServer) {
      config.externals = [
        ...config.externals,
        'puppeteer-core',
        '@sparticuz/chromium',
        '@sparticuz/chromium-min'
      ]
    }
    return config
  },
}

module.exports = nextConfig
