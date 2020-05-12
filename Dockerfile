FROM alpine:latest

RUN apk add --no-cache jq curl

COPY bin /usr/bin
COPY workdir /workdir

# Run some sanity check tests that may fail the building of the image.
# These will only run if the layer is not cached, which should always be the case inside a GitHub Action
COPY test /test
RUN test/test.sh
RUN rm -r /test

ENTRYPOINT "/workdir/entrypoint.sh"
