#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/hetznercloud/cli"
TOOL_NAME="hcloud"
TOOL_TEST="hcloud version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if hcloud is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}-$(get_platform)-$(get_arch).$(get_ext)"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

    mkdir -p "$install_path"/bin
    cp "$ASDF_DOWNLOAD_PATH"/"$tool_cmd" "$install_path"/bin

    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

get_platform() {
  local platform
  platform=$(uname -s | tr '[:upper:]' '[:lower:]')
  if [ "$platform" = "darwin" ]; then
    echo "macos"
  else
    echo "$platform"
  fi
}

get_arch() {
  local arch
  arch=$(uname -m)
  case $arch in
  "x86_64")
    echo "amd64"
    ;;
  "arm")
    echo "armv7" # Super best effort - TODO: find useful way to split armv6/armv7 maybe
    ;;
  "aarch64" | "arm64")
    echo "arm64"
    ;;
  *)
    exit 1
    ;;
  esac
}

get_ext() {
  local platform
  platform=$(uname -s | tr '[:upper:]' '[:lower:]')
  case $platform in
  "linux")
    echo "tar.gz"
    ;;
  "darwin")
    echo "zip"
    ;;
  *)
    exit 1
    ;;
  esac
}

extract() {
  local file download_path ext
  file="$1"
  download_path="$2"
  ext="$(get_ext)"
  case $ext in
  "tar.gz")
    tar -xzf "$file" -C "$download_path"
    ;;
  "zip")
    unzip "$file" -d "$download_path"
    ;;
  *)
    exit 1
    ;;
  esac
}
