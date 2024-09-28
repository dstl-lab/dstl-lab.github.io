// Uses workbox to cache most static resources
// https://developers.google.com/web/tools/workbox/guides/get-started

importScripts(
  'https://storage.googleapis.com/workbox-cdn/releases/4.3.1/workbox-sw.js',
)

workbox.setConfig({ debug: false })

workbox.googleAnalytics.initialize()

workbox.core.setCacheNameDetails({
  prefix: 'samlau.me',
  suffix: 'v1',
})

workbox.routing.registerRoute(
  new RegExp('(/r/.+)$'),
  new workbox.strategies.NetworkFirst(),
)

workbox.routing.registerRoute(
  new RegExp('(/tweak-it.+)$'),
  new workbox.strategies.NetworkFirst(),
)

workbox.routing.registerRoute(
  new RegExp('(/|/projects.*|/about|/cv)$'),
  new workbox.strategies.StaleWhileRevalidate(),
)

workbox.routing.registerRoute(
  /\.(?:png|gif|jpg|jpeg|webp|svg)$/,
  new workbox.strategies.CacheFirst({
    cacheName: 'assets',
    plugins: [
      new workbox.expiration.Plugin({
        maxEntries: 60,
        maxAgeSeconds: 30 * 24 * 60 * 60, // 30 Days
      }),
    ],
  }),
)

workbox.routing.registerRoute(
  /\.(?:js|css|pdf)$/,
  new workbox.strategies.StaleWhileRevalidate(),
)
