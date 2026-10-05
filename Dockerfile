FROM stoplight/prism:4@sha256:08dc16243047a3263beca814b544a5be81e9ec25ca5757cdc4170c84f7431355

COPY openapi.json /spec/openapi.json

# Baked demo spec; override SPEC_PATH (file path or URL) to mock your own API.
# Optional: mount a volume at /specs (never over /spec) and point SPEC_PATH at it.
ENV SPEC_PATH=/spec/openapi.json \
    PORT=4010

# Reset the base ENTRYPOINT (["node","dist/index.js"]) so CMD is self-sufficient
# and $PORT/$SPEC_PATH are resolved at container start by sh.
ENTRYPOINT []
CMD ["sh","-c","node /usr/src/prism/packages/cli/dist/index.js mock -h 0.0.0.0 -p ${PORT:-4010} --cors ${SPEC_PATH:-/spec/openapi.json}"]
