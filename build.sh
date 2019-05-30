#!/bin/bash

# This intended for manually running the integration tests on your own machine
# and assumes that you've cloned the Go repos to your GOPATH and updated them
# with Glide.

mkdir -p bin
pushd bin
go build gitlab.com/elixxir/client
go build -o udb gitlab.com/elixxir/user-discovery-bot
go build gitlab.com/elixxir/gateway
go build gitlab.com/elixxir/server
popd
