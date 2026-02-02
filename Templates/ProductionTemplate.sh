#!/bin/bash
# production_template.sh - Production-ready script template
set -euo pipefail
IFS=$'\n\t'

# Metadata
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VERSION="1.0.0"
# Exit codes
readonly E_SUCCESS=0
readonly E_BADARGS=1
readonly E_NOFILE=2
# Configuration
LOG_FILE="${LOG_FILE:-/tmp/${SCRIPT_NAME}.log}"
DEBUG="${DEBUG:-false}"

# Logging
log() {
echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}
error() {
log "ERROR: $*" >&2
exit "${2:-1}"
}

debug() {
[ "$DEBUG" = "true" ] && log "DEBUG: $*"
}

# Cleanup
cleanup() {
debug "Cleanup called"
[ -f "$temp_file" ] && rm -f "$temp_file"
}
trap cleanup EXIT
# Help
show_help() {
cat << EOF
$SCRIPT_NAME v$VERSION
Usage: $SCRIPT_NAME [OPTIONS] FILE
Process a file with validation and error handling.
OPTIONS:
-h, --help Show this help
-v, --version Show version
-d, --debug Enable debug output
EXAMPLES:
$SCRIPT_NAME input.txt
DEBUG=true $SCRIPT_NAME input.txt
EOF
exit 0
}
# Parse arguments
parse_args() {

while [ $# -gt 0 ]; do
case $1 in
-h|--help) show_help;;
-v|--version) echo "$VERSION"; exit 0;;
-d|--debug) DEBUG=true;;
--) shift; break;;
-*) error "Unknown option: $1" $E_BADARGS;;
*) break;;
esac
shift
done

# Validate required arguments
[ $# -eq 0 ] && error "No file specified" $E_BADARGS
[ ! -f "$1" ] && error "File not found: $1" $E_NOFILE
FILE="$1"
}
# Main processing
process_file() {
local file=$1
log "Processing $file"
debug "File size: $(wc -c < "$file") bytes"
# Create temp file
temp_file=$(mktemp) || error "Cannot create temp file"
debug "Temp file: $temp_file"
# Process (example: remove comments and empty lines)
grep -v '^#' "$file" | grep -v '^$' > "$temp_file"
# Show results
local original=$(wc -l < "$file")
local processed=$(wc -l < "$temp_file")
log "Processed $original lines -> $processed lines"

# Display
echo ""
echo "=== Processed Content ==="
cat "$temp_file"
}

# Main
main() {
log "Starting $SCRIPT_NAME v$VERSION"
parse_args "$@"
process_file "$FILE"
log "Complete"
exit $E_SUCCESS
}

# Run
main "$@"
