---
paths:
  - "app/controllers/**/*.rb"
  - "app/views/**/*"
  - "app/javascript/**/*"
---

# Server-side rendering first

- The server renders HTML and the browser displays it.
- Every UI update goes through Turbo Drive, Turbo Frames or Turbo Streams.
- An endpoint that returns JSON for the client to build or modify the DOM is the last resort. Before writing one, name the critical drawback of server-rendered HTML in a comment next to the endpoint. Examples: a third-party library that only accepts JSON, or a high-frequency update where HTML payload size is measurably the bottleneck.
- "It's easier in JS" and "the frontend needs the data" are not reasons.
- When in doubt, render a partial and return it as a Turbo Stream.

# Client-side behavior

- Prefer Stimulus to organize client-side JavaScript code.
