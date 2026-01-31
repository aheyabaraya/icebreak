#!/usr/bin/env bash
set -euo pipefail

FLUTTER_BIN="${1:-flutter}"

echo "flutter:"
"$FLUTTER_BIN" --version

echo

echo "dart:"
"$FLUTTER_BIN" dart --version

echo

echo "doctor:"
"$FLUTTER_BIN" doctor -v
