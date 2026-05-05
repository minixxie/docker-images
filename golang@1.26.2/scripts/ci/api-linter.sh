#!/bin/bash

# Export buf dependencies to a temp directory so api-linter can resolve proto imports.
# buf generates/downloads these deps during `buf generate`, so the cache is already warm.
PROTO_INCLUDE_DIR=$(mktemp -d)
trap "rm -rf '${PROTO_INCLUDE_DIR}'" EXIT

buf export buf.build/googleapis/googleapis        --output "${PROTO_INCLUDE_DIR}"
buf export buf.build/grpc-ecosystem/grpc-gateway  --output "${PROTO_INCLUDE_DIR}"

find "./pb/" -name "*.proto" | xargs -r \
    bash -c 'if command -v api-linter >/dev/null 2>&1; then
        api-linter "$@"
    else
        # fallback to running api-linter via `go run` (no install required)
        go run github.com/googleapis/api-linter/cmd/api-linter@latest -- "$@"
    fi' _ \
    "-I${PROTO_INCLUDE_DIR}"
