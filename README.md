# Prism Mock Server on Railway

Turn any OpenAPI/Swagger spec into a live mock API. This template runs [Prism](https://github.com/stoplightio/prism) — Stoplight's open-source mock server (Apache-2.0) — and boots healthy immediately with a bundled demo spec. Zero configuration, zero credentials.

## One-click deploy

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/prism-mock-server)

## What you get

The bundled demo spec (`openapi.json`) gives you a working mock API the moment the deployment is green:

| Route | Method | Response |
|---|---|---|
| `/health` | GET | `200` `{"status":"ok"}` |
| `/pets` | GET | `200` list of pets (try `?limit=1`) |
| `/pets` | POST | `201` created pet — body validated against the spec (invalid body → `422`) |
| `/pets/{id}` | GET | `200` a pet; named examples `rex` and `whiskers` |

```bash
curl https://your-app.up.railway.app/health
# {"status":"ok"}

curl https://your-app.up.railway.app/pets/1
# {"id":1,"name":"Rex","species":"dog","status":"available"}
```

## Control responses with the Prefer header

Prism reads a `Prefer` header (or `__`-prefixed query params) to change what it returns:

| Header | Effect |
|---|---|
| `Prefer: example=whiskers` | Return the named example from your spec |
| `Prefer: code=404` | Force a specific status code (response taken from the spec) |
| `Prefer: dynamic=true` | Generate fresh random data from your schemas (faker) |

Combine them: `Prefer: code=404, example=petNotFound`. Query-string equivalents: `?__code=404`, `?__dynamic=true`.

CORS is enabled by default — browsers can call your mock from anywhere. Preflight `OPTIONS` requests get `204`.

## Mock your own API

Three ways, pick any:

1. **Fork this repo** — edit `openapi.json` (any OpenAPI 2/3 or Postman collection works), then deploy *your fork* on Railway.
2. **Point at a URL** — set the `SPEC_PATH` variable to a spec URL, e.g. `https://example.com/openapi.yaml`, and redeploy.
3. **Mount a volume** — attach a Railway volume at `/specs` (never mount over `/spec` — that would shadow the baked-in spec and break boot), put your spec in it, and set `SPEC_PATH=/specs/my-spec.json`.

Prism validates every request and response against your spec, so a malformed POST returns a `422` with a problem+json body — that's contract testing for free.

## Configuration

| Variable | Default | Description |
|---|---|---|
| `PORT` | Railway-assigned | Port Prism listens on. Railway sets this automatically — no need to touch it. Outside Railway (e.g. local Docker) it defaults to `4010` |
| `SPEC_PATH` | `/spec/openapi.json` | Path or URL of the OpenAPI document to serve |

## Alternatives

Need response templating (dynamic bodies from request data)? [WireMock](https://wiremock.org) 3 with `--global-response-templating` is a good fit. This template ships Prism as the default: it is lighter, spec-first, and validates traffic out of the box.

## Credits

[Prism](https://github.com/stoplightio/prism) by Stoplight, Apache License 2.0. This repository's scaffolding is MIT licensed.
