#!/usr/bin/env bash
# =============================================================
#  PMK Temple Architect — FTP Deploy Script
#  Usage:  ./deploy.sh [options]
#
#  Options:
#    --skip-build   Skip building the Nuxt static site
#    --skip-images  Skip uploading the gallery/ directory (only deploy code)
#    --only-images  Only upload the gallery/ directory (skip code/pages)
#
#  Reads credentials from .deploy.env (never committed to git)
#  Builds the Nuxt static site → uploads .output/public/ to Zolahost
# =============================================================

set -uo pipefail   # Note: no -e so curl FTP errors don't abort

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
echo "  ║   P.M.K. Temple Architect — Deploy Script   ║"
echo "  ║   Target: pmktemplearchitect.charnithi.com  ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${RESET}"

# ── Parse arguments ───────────────────────────────────────────
SKIP_BUILD=false
SKIP_IMAGES=false
ONLY_IMAGES=false

for arg in "$@"; do
  case $arg in
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

# If no images flag is passed, ask the user interactively
if [[ "$SKIP_IMAGES" == "false" && "$ONLY_IMAGES" == "false" ]]; then
  if [[ -t 0 ]]; then
    # Interactive shell
    echo -e "${BOLD}Would you like to deploy the gallery images?${RESET}"
    echo "  Since there are 129 heavy images, skipping them makes deploy 10x faster."
    read -p "  Upload images? [y/N]: " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      SKIP_IMAGES=true
      info "Skipping gallery images. Code/layout changes only."
    else
      info "Deploying complete website including all gallery images."
    fi
  else
    # Non-interactive shell (default to skip images to save bandwidth)
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

# ── Step 2: Upload ────────────────────────────────────────────
UPLOAD_ERRORS=0

# curl-based recursive FTP upload (robust, no pipefail abort on mkdir)
ftp_mkdir() {
  curl --silent \
       --user "$FTP_USER:$FTP_PASS" \
       --ftp-create-dirs \
       "ftp://$FTP_HOST$1/" \
       -Q "MKD $1" \
       --output /dev/null 2>/dev/null || true
}

ftp_upload_file() {
  local local_file="$1"
  local remote_path="$2"
  local fname
  fname="$(basename "$local_file")"
  local display_path="${remote_path}/${fname}"

  # Show progress
  local fsize
  fsize=$(stat -c%s "$local_file" 2>/dev/null || echo "?")
  printf "  %-70s %s\n" "$display_path" "(${fsize}B)"

  local result
  result=$(curl --silent --show-error \
                --ftp-create-dirs \
                --user "$FTP_USER:$FTP_PASS" \
                -T "$local_file" \
                "ftp://$FTP_HOST$remote_path/$fname" 2>&1) || {
    warn "FAILED: $display_path → $result"
    UPLOAD_ERRORS=$((UPLOAD_ERRORS + 1))
  }
}

# Count files to upload to display correct progress
count_files() {
  local local_dir="$1"
  local count=0

  local process_files=true
  if [[ "$ONLY_IMAGES" == "true" && "$local_dir" != *"/gallery"* ]]; then
    process_files=false
  fi

  if [[ "$process_files" == "true" ]]; then
    count=$(find "$local_dir" -maxdepth 1 -type f | wc -l)
  fi

  while IFS= read -r -d '' subdir; do
    local dname
    dname="$(basename "$subdir")"
    
    local recurse=true
    if [[ "$dname" == "gallery" && "$SKIP_IMAGES" == "true" ]]; then
      recurse=false
    fi
    if [[ "$dname" == "unzipped_raw" ]]; then
      recurse=false
    fi
    if [[ "$ONLY_IMAGES" == "true" && "$dname" != "gallery" && "$local_dir" == "$DIST_DIR" ]]; then
      recurse=false
    fi
    
    if [[ "$recurse" == "true" ]]; then
      local sub_count
      sub_count=$(count_files "$subdir")
      count=$((count + sub_count))
    fi
  done < <(find "$local_dir" -maxdepth 1 -mindepth 1 -type d -print0)

  echo "$count"
}

info "Calculating files to upload..."
FILE_COUNT=$(count_files "$DIST_DIR")
info "Step 2/3 — Uploading $FILE_COUNT files to ftp://$FTP_HOST$FTP_REMOTE_DIR ..."

upload_dir() {
  local local_dir="$1"
  local remote_dir="$2"

  # Ensure remote dir exists
  ftp_mkdir "$remote_dir"

  local process_files=true
  if [[ "$ONLY_IMAGES" == "true" && "$local_dir" != *"/gallery"* ]]; then
    process_files=false
  fi

  if [[ "$process_files" == "true" ]]; then
    while IFS= read -r -d '' file; do
      ftp_upload_file "$file" "$remote_dir"
    done < <(find "$local_dir" -maxdepth 1 -type f -print0)
  fi

  # Recurse into subdirs
  while IFS= read -r -d '' subdir; do
    local dname
    dname="$(basename "$subdir")"
    
    local recurse=true
    if [[ "$dname" == "gallery" && "$SKIP_IMAGES" == "true" ]]; then
      recurse=false
    fi
    if [[ "$dname" == "unzipped_raw" ]]; then
      recurse=false
    fi
    if [[ "$ONLY_IMAGES" == "true" && "$dname" != "gallery" && "$local_dir" == "$DIST_DIR" ]]; then
      recurse=false
    fi
    
    if [[ "$recurse" == "true" ]]; then
      upload_dir "$subdir" "$remote_dir/$dname"
    fi
  done < <(find "$local_dir" -maxdepth 1 -mindepth 1 -type d -print0)
}

upload_dir "$DIST_DIR" "$FTP_REMOTE_DIR"

# ── Step 3: Done ──────────────────────────────────────────────
echo ""
if [[ "$UPLOAD_ERRORS" -eq 0 ]]; then
  success "Step 3/3 — Deploy complete! All $FILE_COUNT files uploaded."
else
  warn "Step 3/3 — Deploy finished with $UPLOAD_ERRORS error(s). Check output above."
fi

echo ""
echo -e "  ${BOLD}🌐 Live at:${RESET}  https://pmktemplearchitect.charnithi.com"
echo -e "  ${BOLD}📁 Remote:${RESET}   ftp://$FTP_HOST$FTP_REMOTE_DIR"
echo -e "  ${BOLD}📦 Files:${RESET}    $FILE_COUNT total | $UPLOAD_ERRORS failed"
echo ""
