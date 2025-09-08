#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT="${1:-Production}"

# Where to look (repo root expected)
ROOT_DIR="$(pwd)"

# ADF conventional folders
PIPE_DIR="${ROOT_DIR}/pipeline"
DATASET_DIR="${ROOT_DIR}/dataset"
DATAFLOW_DIR="${ROOT_DIR}/dataflow"

# Output: list of FOLDERS to EXCLUDE (i.e., ready for Production per your ask)
OUT_DIR="${ROOT_DIR}/.tmp"
mkdir -p "${OUT_DIR}"
READY_LIST="${OUT_DIR}/ready_folders.txt"
> "${READY_LIST}"

#color() { :; } # no-op for CI logs; keep simple

# Helper: safe folder token from a JSON file (pipeline/dataset/dataflow)
get_folder_token() {
  local json="$1"
  # Prefer .properties.folder.name if present; else "ROOT"
  local has_folder
  has_folder="$(jq -r '.properties | has("folder")' "${json}")"
  if [[ "${has_folder}" == "true" ]]; then
    # Take only the first path segment as the "feature/folder"
    jq -r '.properties.folder.name' "${json}" | awk -F'/' '{print $1}'
  else
    echo "ROOT"
  fi
}

# Collect all folders that have ANY pipeline annotated with ENVIRONMENT
declare -A ready_folders=()

shopt -s nullglob

if [[ -d "${PIPE_DIR}" ]]; then
  for f in "${PIPE_DIR}"/*.json; do
    echo "f: $f" #added this -Joe
    # Check annotations array presence
    anno_present="$(jq -r '.properties | has("annotations")' "${f}")"
    if [[ "${anno_present}" == "true" ]]; then
      echo "annotation present." #added this -Joe
      contains_env="$(jq --arg env "${ENVIRONMENT}" -r '.properties.annotations | contains([$env])' "${f}")"
      if [[ "${contains_env}" == "false" ]]; then #changed this to exclude anything which doesn't match -Joe
        echo "Enviornment NOT present." #added this -Joe
        folder_token="$(get_folder_token "${f}")"
        echo "folder token: $folder_token" #added this -Joe
        ready_folders["${folder_token}"]=1
      fi
    fi
  done
fi

# Emit unique folder tokens to READY_LIST
for folder in "${!ready_folders[@]}"; do
  echo "${folder}" >> "${READY_LIST}"
done

# Show what we found (for logs)
echo "Folders marked READY for ${ENVIRONMENT}:"
if [[ -s "${READY_LIST}" ]]; then
  sort -u "${READY_LIST}" | sed 's/^/  - /'
else
  echo "  (none)"
fi

# Also expose as a GitHub Actions output if running inside GH Actions
if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  # Comma-separated list
  CSV="$(tr '\n' ',' < "${READY_LIST}" | sed 's/,$//')"
  echo "ready_folders=${CSV}" >> "${GITHUB_OUTPUT}"
fi
