---
paths:
  - "app/controllers/**/*.rb"
  - "app/views/**/*"
  - "app/javascript/**/*"
---

# Server-side rendering first

- The server renders HTML; the browser displays it. Every UI update goes through Turbo Drive, Turbo Frames or Turbo Streams, with Stimulus limited to behavior that needs no server data (toggles, focus, formatting).
- Endpoints that return JSON for the client to build or modify the DOM are the ultimate exception. Before writing one, name the critical drawback of doing it with server-rendered HTML (e.g. a third-party library that only accepts JSON, or a high-frequency update where HTML payload size is measurably the bottleneck) in a comment next to the endpoint. "It's easier in JS" or "the frontend needs the data" is not a reason.
- When in doubt, render a partial and return it as a Turbo Stream.
