#!/bin/sh
# Generate a flatpak-builder sources manifest (cargo-sources.json) from a
# Cargo.lock using upstream's flatpak-cargo-generator.py.
#
# Run this inside a toolbox: it builds a self-contained venv there so the
# host python is never touched. All state lives in tools/cargo-generator/;
# delete that directory to reset the tool.
#
# Usage:
#   tools/generate-cargo-sources.sh /path/to/Cargo.lock -o cargo-sources.json
#
# All arguments are passed to the generator verbatim; run it with --help
# for the full option set (-o, -t, --yaml, ...).
#
# The generator is pinned to a fixed upstream revision for reproducible
# output; override with GENERATOR_REF=<git sha> to test a newer one.
set -eu
cd "$(dirname "$0")"

GENERATOR_REF="${GENERATOR_REF:-74697c75b630d7330e77250fc13cb5ea688d9479}"
GENERATOR_URL_BASE="https://raw.githubusercontent.com/flatpak/flatpak-builder-tools"
# Runtime deps from upstream cargo/pyproject.toml at the pinned revision.
DEPS="aiohttp>=3.9.5,<4.0.0 PyYAML>=6.0.2,<7.0.0 tomlkit>=0.13.3,<1.0"

STATE=cargo-generator
VENV="$STATE/venv"
REF_FILE="$STATE/ref"
SCRIPT="$STATE/flatpak-cargo-generator.py"

# Toolbox sets $container and drops /run/.containerenv. Outside one this
# still works, it just creates the venv on the host instead.
if [ "${container:-}" != toolbox ] && [ ! -f /run/.containerenv ]; then
  echo "note: not running inside a toolbox; using host python3" >&2
fi

python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 9) else 1)' || {
  echo "error: flatpak-cargo-generator needs python >= 3.9" >&2
  exit 1
}
command -v curl >/dev/null || { echo "error: curl is required" >&2; exit 1; }

mkdir -p "$STATE"
if [ ! -d "$VENV" ]; then
  python3 -m venv "$VENV"
fi
# shellcheck disable=SC1091
. "$VENV/bin/activate"
# Idempotent: a no-op when the venv already satisfies the pins.
pip install --quiet $DEPS

if [ ! -f "$SCRIPT" ] || [ "$(cat "$REF_FILE" 2>/dev/null)" != "$GENERATOR_REF" ]; then
  echo "Fetching flatpak-cargo-generator.py @ $GENERATOR_REF" >&2
  curl -fsSL "$GENERATOR_URL_BASE/$GENERATOR_REF/cargo/flatpak-cargo-generator.py" -o "$SCRIPT"
  printf '%s\n' "$GENERATOR_REF" >"$REF_FILE"
fi

exec python "$SCRIPT" "$@"
