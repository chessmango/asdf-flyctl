<div align="center">

# asdf-hcloud [![Build](https://github.com/chessmango/asdf-hcloud/actions/workflows/build.yml/badge.svg)](https://github.com/chessmango/asdf-hcloud/actions/workflows/build.yml) [![Lint](https://github.com/chessmango/asdf-hcloud/actions/workflows/lint.yml/badge.svg)](https://github.com/chessmango/asdf-hcloud/actions/workflows/lint.yml)


[hcloud](https://github.com/hetznercloud/cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add hcloud https://github.com/chessmango/asdf-hcloud.git
```

hcloud:

```shell
# Show all installable versions
asdf list-all hcloud

# Install specific version
asdf install hcloud latest

# Set a version globally (on your ~/.tool-versions file)
asdf global hcloud latest

# Now hcloud commands are available
hcloud version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/chessmango/asdf-hcloud/graphs/contributors)!

# License

See [LICENSE](LICENSE)
