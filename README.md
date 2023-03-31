# init

See the [organization](https://github.com/quasipanacea) for details.

## Installation (production)

```sh
cargo install quasipanacea-cli

quasipanacea-cli install
quasipanacea-cli run
```

## Installation (development)

This installs all GitHub repositories that are part of Quasipanacea. The target directory of the installation is the current working directory.

```sh
curl -#fLo- 'https://raw.githubusercontent.com/quasipanacea/init/main/scripts/install.sh' | bash
```
