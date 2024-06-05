#!/usr/bin/env bash

export LANG=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

REQUIRED_BUNDLE_VERSION=2.3.17

ruby --version
which ruby

gem "install" "bundler" "--force" "--no-document" "--version" "$REQUIRED_BUNDLE_VERSION"
bundle "install" "--jobs" "20" "--retry" "5"
bundle "exec" "fastlane" "--version"

bundle "$@"
