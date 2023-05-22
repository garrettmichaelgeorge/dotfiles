#!/bin/sh

# This is a shim to allow the $BROWSER to be read on macos by gh and possibly
# other CLI utilities.
#
# https://github.com/github/hub/issues/2178#issuecomment-506352200

set -eu

exec '/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox' "$@"
