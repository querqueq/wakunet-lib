#!/bin/sh
cabal update
cabal install --only-dependencies
cabal configure
cabal build
cp -f dist/build/timeline-service/timeline-service bin/wakunet-timeline-service_x86_64
