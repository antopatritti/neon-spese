// Cambia il numero ad ogni pubblicazione per forzare l'aggiornamento della cache.
const CACHE = 'neon-spese-cache-v3';
const FILES = ['./', './index.html', './config.js', './manifest.webmanifest', './icon.svg', './icon-192.png', './icon-512.png'];
self.addEventListener('install', event => {
  event.waitUntil(caches.open(CACHE).then(cache => cache.addAll(FILES.map(f => new Request(f, { cache: 'reload' })))));
  self.skipWaiting();
});
self.addEventListener('activate', event => {
  event.waitUntil(caches.keys().then(keys => Promise.all(keys.filter(key => key !== CACHE).map(key => caches.delete(key)))));
  self.clients.claim();
});
self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  // Mai intercettare Supabase (dati/login) né CDN: solo i file del sito.
  if (event.request.method !== 'GET' || url.origin !== self.location.origin) return;
  // Rete per prima (file sempre aggiornati), cache solo se sei offline.
  event.respondWith(
    fetch(event.request, { cache: 'no-cache' }).then(response => {
      if (response.ok) { const copy = response.clone(); caches.open(CACHE).then(cache => cache.put(event.request, copy)); }
      return response;
    }).catch(() => caches.match(event.request).then(c => c || caches.match('./index.html')))
  );
});
