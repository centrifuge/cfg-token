# CFG token [![Github Actions][gha-badge]][gha] [![Foundry][foundry-badge]][foundry] [![License: GPL v2](https://img.shields.io/badge/License-GPL_v2-blue.svg)](https://github.com/centrifuge/cfg-token/blob/main/LICENSE)
[gha]: https://github.com/centrifuge/cfg-token/actions
[gha-badge]: https://github.com/centrifuge/cfg-token/actions/workflows/ci.yml/badge.svg
[foundry]: https://getfoundry.sh
[foundry-badge]: https://img.shields.io/badge/Built%20with-Foundry-FFDB1C.svg

Codebase for the Centrifuge token, which includes support for onchain delegation.

## Developing
#### Getting started
```sh
git clone git@github.com:centrifuge/cfg-token.git
cd cfg-token
forge update
```

#### Testing
To build and run all tests locally:
```sh
forge test
```

## Audit reports

TODO

## License

The codebase is licensed under `GPL-2.0-or-later`, see [`LICENSE`](./LICENSE).

The onchain delegation logic is adapted from the [https://github.com/morpho-org/morpho-token](Morpho token).