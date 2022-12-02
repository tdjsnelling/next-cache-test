const { createServer } = require('http')
const { parse } = require('url')
const next = require('next')

const dev = process.env.NODE_ENV !== 'production'
const hostname = process.env.HOST || 'localhost'
const port = process.env.PORT || 3000

const app = next({ dev, hostname, port })
const handle = app.getRequestHandler()

const etag = `"${process.env.NF_GIT_SHA}"`

app.prepare().then(() => {
  createServer(async (req, res) => {
    try {
      const parsedUrl = parse(req.url, true)
      const { pathname } = parsedUrl

      // we don't want to apply custom caching to API routes
      if (!pathname.startsWith('/api')) {
        const ifNoneMatch = req.headers['if-none-match']
        if (ifNoneMatch === etag) {
          res.statusCode = 304
          res.end()
          return
        }

        res.setHeader('Cache-Control', 'max-age=300')
        res.setHeader('ETag', etag)
      }

      await handle(req, res, parsedUrl)
    } catch (err) {
      console.error('Error occurred handling', req.url, err)
      res.statusCode = 500
      res.end('internal server error')
    }
  }).listen(port, (err) => {
    if (err) throw err
    console.log(`> Ready on http://${hostname}:${port}`)
  })
})
