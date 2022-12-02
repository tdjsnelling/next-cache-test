/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  generateEtags: false,
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'etag',
            value: `${process.env.NF_GIT_SHA}`
          }
        ]
      }
    ]
  }
}

module.exports = nextConfig
