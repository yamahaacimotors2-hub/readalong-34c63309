// Minimal offline shell; chapter audio streams from the network (and browser HTTP cache).
const C='hbrab-v2', SHELL=['./','index.html','manifest.webmanifest','icon.svg','icon-192.png','icon-512.png','data/index.json'];
self.addEventListener('install',e=>e.waitUntil(caches.open(C).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting())));
self.addEventListener('activate',e=>e.waitUntil(self.clients.claim()));
self.addEventListener('fetch',e=>{ const u=new URL(e.request.url); if(e.request.method!=='GET'||u.pathname.endsWith('.mp3')) return;
  e.respondWith(fetch(e.request).then(r=>{ const cp=r.clone(); caches.open(C).then(c=>c.put(e.request,cp)); return r; }).catch(()=>caches.match(e.request))); });
