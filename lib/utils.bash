#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/superfly/flyctl"
TOOL_NAME="flyctl"
TOOL_TEST="flyctl version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if flyctl is not hosted on GitHub releases.
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

  url="$GH_REPO/releases/download/v${version}/${TOOL_NAME}_${version}_$(get_platform)_$(get_arch).tar.gz"

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
  platform=$(uname -s)
  if [ "$platform" = "Darwin" ]; then
    echo "macOS"
  else
    echo "$platform"
  fi
}

get_arch() {
  local arch
  arch=$(uname -m)

  if [[ "$arch" == "aarch64" ]]; then
    echo "arm64"
  else
    echo "$arch"
  fi
}

extract() {
  local file download_path
  file="$1"
  download_path="$2"
  tar -xzf "$file" -C "$download_path"
}
