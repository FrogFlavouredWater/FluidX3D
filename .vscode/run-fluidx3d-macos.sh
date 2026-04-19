#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

open -a XQuartz >/dev/null 2>&1 || true
export DISPLAY=:0

for _ in {1..30}; do
	if /opt/X11/bin/xset q >/dev/null 2>&1; then
		break
	fi
	sleep 1
done

if ! /opt/X11/bin/xset q >/dev/null 2>&1; then
	echo "Error: XQuartz did not become available on DISPLAY=:0."
	echo "Try quitting XQuartz completely, reopening it once, then running this again."
	exit 1
fi

make macOS -j8

if [[ "${1:-}" == "--build-only" ]]; then
	mkdir -p src/build/Debug
	ln -sf ../../../bin/FluidX3D src/build/Debug/outDebug
	exit 0
fi

if [[ "${1:-}" == "--active-file-shim" ]]; then
	mkdir -p src/build/Debug
	ln -sf ../../../bin/FluidX3D src/build/Debug/outDebug
	shift
	if [[ "${1:-}" != "" ]]; then
		rm -f "$1"
		ln -sf "$PWD/bin/FluidX3D" "$1"
	fi
	exit 0
fi

exec ./bin/FluidX3D "$@"
