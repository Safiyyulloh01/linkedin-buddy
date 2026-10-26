#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "  LinkedIn Buddy — Pipeline Verification"
echo "=========================================="

echo "[1/3] Running ESLint..."
node node_modules/eslint/bin/eslint.js .

echo "[2/3] Checking TypeScript across all packages..."
node node_modules/typescript/bin/tsc -b --pretty false --force

echo "[3/3] Building production packages..."
node node_modules/typescript/bin/tsc -b --pretty false

echo "=========================================="
echo "  All Quality Gates Passed Cleanly!"
echo "=========================================="
