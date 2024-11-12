# *Smart Contracts* de Permissionamento da RBB - Segunda Geração

## Ambiente de desenvolvimento

Para baixar as dependências:

```shell
npm install
```

Para compilar os *smart contracts* (configurado no `package.json`):

```shell
npm run compile
```

Para inicar o Hardhat:

```shell
npx hardhat node
```

Para implantar os *smart contracts* (configurado no `package.json`):

```shell
npm run ignition
```

## Debug

### Cucumber

https://github.com/cucumber/cucumber-js/blob/main/docs/debugging.md

Ajustar variável de ambiente `DEBUG=cucumber`

### Hardhat

https://hardhat.org/hardhat-runner/docs/troubleshooting/verbose-logging


Ajustar variável de ambiente `HARDHAT_VERBOSE=true`


## Referências

- [HardHat](https://hardhat.org/hardhat-runner/docs/getting-started)
- [Creating Ingnition Modules](https://hardhat.org/ignition/docs/guides/creating-modules)
- [Deploying your contracts](https://hardhat.org/hardhat-runner/docs/guides/deploying)
- [Deploying a module](https://hardhat.org/ignition/docs/guides/deploy)
- [Hardhat Network](https://hardhat.org/hardhat-network/docs/overview)
- [Testing contracts](https://hardhat.org/hardhat-runner/docs/guides/test-contracts)
- [Debugging with Hardhat Network](https://hardhat.org/tutorial/debugging-with-hardhat-network)
  - console.log [overview](https://hardhat.org/hardhat-network/docs/overview#console.log)
  - console.log [reference](https://hardhat.org/hardhat-network/docs/reference#console.log)
- [Cucumber JS](https://github.com/cucumber/cucumber-js)
- [Gherkin Syntax](https://cucumber.io/docs/gherkin/)
- [Hardhat-Ethers](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers)
- [Ethers API](https://docs.ethers.org/v6/single-page/#api)
- Mocha - [Assertions](https://mochajs.org/#assertions)
- Node.js - [Assert](https://nodejs.org/api/assert.html)
- [Role-Based Access Control](https://docs.openzeppelin.com/contracts/2.x/access-control#role-based-access-control)
