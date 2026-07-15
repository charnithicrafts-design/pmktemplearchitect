#!/usr/bin/env bash
# =============================================================
#  PMK Temple Architect — FTP Deploy Script (FAST ZIP METHOD)
#  Usage:  ./deploy.sh [options]
#
#  Options:
#    --skip-build   Skip building the Nuxt static site
#    --skip-images  Skip uploading the gallery/ directory (only deploy code)
#    --only-images  Only upload the gallery/ directory (skip code/pages)
#
#  Reads credentials from .deploy.env (never committed to git)
# =============================================================

set -uo pipefail

# ── Colours ───────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}ℹ  $*${RESET}"; }
success() { echo -e "${GREEN}✔  $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠  $*${RESET}"; }
error()   { echo -e "${RED}✖  $*${RESET}" >&2; exit 1; }

# ── Banner ────────────────────────────────────────────────────
echo -e "${BOLD}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║   P.M.K. Temple Architect — Fast Deploy     ║"
echo "  ║   Target: pmktemplearchitect.charnithi.com  ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${RESET}"

# ── Parse arguments ───────────────────────────────────────────
SKIP_BUILD=false
SKIP_IMAGES=false
ONLY_IMAGES=false

for arg in "$@"; do
  case $arg in
    --all)
      SKIP_IMAGES=false
      ONLY_IMAGES=false
      FORCE_ALL=true
      ;;
    --skip-build)
      SKIP_BUILD=true
      ;;
    --skip-images)
      SKIP_IMAGES=true
      ;;
    --only-images)
      ONLY_IMAGES=true
      ;;
  esac
done

if [[ "${FORCE_ALL:-false}" == "false" && "$SKIP_IMAGES" == "false" && "$ONLY_IMAGES" == "false" ]]; then
  if [[ -t 0 ]]; then
    echo -e "${BOLD}Would you like to deploy the gallery images?${RESET}"
    read -p "  Upload images? [y/N]: " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      SKIP_IMAGES=true
      info "Skipping gallery images. Code/layout changes only."
    else
      info "Deploying complete website including all gallery images."
    fi
  else
    SKIP_IMAGES=true
    warn "Non-interactive shell: defaulting to skip gallery images (use --only-images to push them)."
  fi
fi

# ── Load credentials ──────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.deploy.env"
[[ ! -f "$ENV_FILE" ]] && error ".deploy.env not found at $ENV_FILE"

set -a; source "$ENV_FILE"; set +a

for var in FTP_HOST FTP_USER FTP_PASS FTP_REMOTE_DIR; do
  [[ -z "${!var:-}" ]] && error "Missing $var in .deploy.env"
done

DIST_DIR="$SCRIPT_DIR/.output/public"

# ── Step 1: Build ─────────────────────────────────────────────
if [[ "$SKIP_BUILD" == "false" ]]; then
  info "Step 1/3 — Building Nuxt static site..."
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  cd "$SCRIPT_DIR"
  npm run generate || error "Build failed"
  success "Build complete → $DIST_DIR"
else
  warn "Skipping build (--skip-build passed)"
fi

[[ ! -d "$DIST_DIR" ]] && error "Dist directory not found: $DIST_DIR — run without --skip-build first."

# ── Step 2: Zip files ─────────────────────────────────────────
info "Step 2/3 — Zipping files for blazing fast transfer..."
cd "$DIST_DIR"

# Remove any old deployment artifacts
rm -f deploy.zip unzip.php

if [[ "$ONLY_IMAGES" == "true" ]]; then
  # Only zip the gallery folder
  zip -q -r deploy.zip gallery/
elif [[ "$SKIP_IMAGES" == "true" ]]; then
  # Zip everything except gallery/ and unzipped_raw/
  zip -q -r deploy.zip . -x "gallery/*" -x "unzipped_raw/*"
else
  # Zip everything except unzipped_raw/
  zip -q -r deploy.zip . -x "unzipped_raw/*"
fi

ZIP_SIZE=$(stat -c%s deploy.zip 2>/dev/null || stat -f%z deploy.zip)
success "Zipped files into deploy.zip ($ZIP_SIZE bytes)"

# Create PHP extraction script
cat << 'EOF' > unzip.php
<?php
$zipFile = 'deploy.zip';
$zip = new ZipArchive;
if ($zip->open($zipFile) === TRUE) {
    $zip->extractTo('./');
    $zip->close();
    echo "OK";
    unlink($zipFile);
    unlink(__FILE__);
} else {
    echo "FAILED";
}
?>
EOF

# ── Step 3: Upload and Extract ────────────────────────────────
info "Step 3/3 — Uploading archive and triggering extraction..."

curl --silent --show-error \
     --ftp-create-dirs \
     --user "$FTP_USER:$FTP_PASS" \
     -T "deploy.zip" \
     "ftp://$FTP_HOST$FTP_REMOTE_DIR/deploy.zip" || error "Failed to upload deploy.zip"

curl --silent --show-error \
     --ftp-create-dirs \
     --user "$FTP_USER:$FTP_PASS" \
     -T "unzip.php" \
     "ftp://$FTP_HOST$FTP_REMOTE_DIR/unzip.php" || error "Failed to upload unzip.php"

success "Upload complete. Triggering extraction on server..."

RESULT=$(curl --silent --show-error "https://pmktemplearchitect.charnithi.com/unzip.php")

if [[ "$RESULT" == "OK" ]]; then
  success "Server successfully extracted all files!"
else
  error "Extraction script failed. Output: $RESULT"
fi

# Cleanup
rm -f deploy.zip unzip.php

echo ""
echo -e "  ${BOLD}🌐 Live at:${RESET}  https://pmktemplearchitect.charnithi.com"
echo -e "  ${BOLD}🚀 Deployment Strategy:${RESET} PHP ZipArchive"
echo ""
