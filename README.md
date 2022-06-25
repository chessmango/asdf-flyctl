<div align="center">

# asdf-flyctl [![Build](https://github.com/chessmango/asdf-flyctl/actions/workflows/build.yml/badge.svg)](https://github.com/chessmango/asdf-flyctl/actions/workflows/build.yml) [![Lint](https://github.com/chessmango/asdf-flyctl/actions/workflows/lint.yml/badge.svg)](https://github.com/chessmango/asdf-flyctl/actions/workflows/lint.yml)


[flyctl](https://github.com/superfly/flyctl) plugin for the [asdf version manager](https://asdf-vm.com).

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
asdf plugin add flyctl https://github.com/chessmango/asdf-flyctl.git
```

flyctl:

```shell
# Show all installable versions
asdf list-all flyctl

# Install specific version
asdf install flyctl latest

# Set a version globally (on your ~/.tool-versions file)
asdf global flyctl latest

# Now flyctl commands are available
flyctl version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/chessmango/asdf-flyctl/graphs/contributors)!

# License

See [LICENSE](LICENSE)
