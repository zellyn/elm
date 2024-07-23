description = "elm-format formats Elm source code according to a standard set of rules based on the official Elm Style Guide."

binaries = ["elm-format"]
test = "elm-format -h"

version "0.8.7" {
  auto-version {
    github-release = "avh4/elm-format"
  }

  platform "darwin" "amd64" {
    source = "https://github.com/avh4/elm-format/releases/download/${version}/elm-format-${version}-mac-x64.tgz"
  }

  platform "darwin" "arm64" {
    source = "https://github.com/avh4/elm-format/releases/download/${version}/elm-format-${version}-mac-arm64.tgz"
  }

  platform "linux" "amd64" {
    source = "https://github.com/avh4/elm-format/releases/download/${version}/elm-format-${version}-linux-x64.tgz"
  }

  platform "linux" "arm64" {
    source = "https://github.com/avh4/elm-format/releases/download/${version}/elm-format-${version}-linux-arm64.tgz"
  }
}

sha256sums = {
}
