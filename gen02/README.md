# *Smart Contracts* de Permissionamento da RBB - Segunda Geração (gen02)

## Ambiente de desenvolvimento

### Preparação do ambiente

Para baixar as dependências:

```shell
npm install
```


### Construção e testes

Para compilar os *smart contracts* (script configurado no `package.json`):

```shell
npm run compile
```

Para executar os testes automatizados:

```shell
npm test
```

**Observação**: Os testes são baseados em cenários, descritos **em linguagem natural**, utilizando a sintaxe [Gherkin](https://cucumber.io/docs/gherkin/). Os cenários podem ser encontrados na pasta [features](features).


### Debug

#### Cucumber

https://github.com/cucumber/cucumber-js/blob/main/docs/debugging.md

Ajustar variável de ambiente `DEBUG=cucumber`


#### Hardhat

https://hardhat.org/hardhat-runner/docs/troubleshooting/verbose-logging

Ajustar variável de ambiente `HARDHAT_VERBOSE=true`


#### Log nos *smart contracts*

O Hardhat permite utilizar função de log na console, de forma análoga ao Javascript (ver referência abaixo).

Exemplo:
```
import "hardhat/console.sol";

...

console.log("Parametros %s e %s", p1, p2);
```

**ATENÇÃO**: Esse recurso deve ser usado apenas em testes locais, de forma temporária. Tal recurso **não** pode ser usado para utilização efetiva no código final. **Remova quaisquer referências do tipo antes de fazer commit do código**.


### Implantação Local

Para inicar o Hardhat:

```shell
npx hardhat node
```

Para implantar os *smart contracts* (scripts configurados no `package.json`) em nó local Hardhat:

1. Implantar contrato *mock* de [`AdminProxy`](../gen01/contracts/AdminProxy.sol):

```shell
npm run ignition-mock
```

2. Implantar os contratos de permissionamento:

```shell
npm run ignition-local
```


### Implantação na Rede Lab


### Implantação na Rede Piloto


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
