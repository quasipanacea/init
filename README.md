# init

See the [organization](https://github.com/quazipanacea) for details.

## Installation (production)

```sh
cargo install quazipanacea-cli

quazipanacea-cli install
quazipanacea-cli run
```

## Installation (development)

This installs all GitHub repositories that are part of Quazipanacea. The target directory of the installation is the current working directory.

```sh
curl -#fLo- 'https://raw.githubusercontent.com/quazipanacea/init/main/scripts/install.sh' | bash
```
