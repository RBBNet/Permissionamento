# *Smart Contracts* de Permissionamento da RBB - Segunda Geração (gen02)

Esta pasta contém os *smart contracts* de permissionamento da RBB de segunda geração e vários outros artefatos de [documentação](doc), testes e de [implantação](deploy), organizados como um [projeto npm](package.json).

A gen02 foi desenvolvida para endereçar riscos e trazer melhorias conceituais em relação a gen01. A saber:

- Conceito de [organização](contracts/OrganizationImpl.sol).
  - Contas e nós são sempre associados a uma organização.
  - Público pode consultar na blockchain quem faz parte da RBB.
- Mecanismo de [governança](contracts/Governance.sol).
  - Ações de caráter global da rede são feitos mediante propostas/votações.
  - Um voto por organização.
  - Aprovação por maioria simples.
  - Diminuição do poder de um único administrador (risco de segurança).
  - Funcionamento da RBB mais próximo ao de uma DAO.
- [Contas](contracts/AccountRulesV2Impl.sol) com perfis de acesso.
  - Permissões de acesso mais granulares.
  - 4 perfis de acesso previstos:
    - Usuário (`USER_ROLE`): Pode enviar transações.
    - Implantador (`DEPLOYER_ROLE`): Pode implantar smart contracts.
    - Administrador Local (`LOCAL_ADMIN_ROLE`): Efetua o permissionamento de nós e contas da organização.
    - Administrador Global (`GLOBAL_ADMIN_ROLE`): Representa a organização para ações de governança da rede.
- *Hash* cadastral para [contas](contracts/AccountRulesV2Impl.sol).
  - Conforme item 7.5.4 do [Manual de Operações da RBB](https://github.com/RBBNet/rbb/blob/master/governanca/reunioes_comite_executivo/atas/2023-12-14-RBB-Ata-Reuni%C3%A3o-Comit%C3%AA-Executivo_v3_assinada.pdf).
- Mecanismo para restrição de acesso por [contas](contracts/AccountRulesV2Impl.sol).
  - Desabilitação de contas.
  - Limitação de endereços alvo de transações por conta.
  - Reversão de restrições de acesso aplicadas a uma conta.
  - Restrições aplicáveis por qualquer administrador da organização.
- Mecanismo para restrição de acesso a *smart contracts*.
  - Desabilitação completa de acesso a um *smart contract*.
  - Limitação de acesso a um *smart contract* por *senders* específicos.
  - Reversão de restrições de acesso aplicadas a um *smart contract*.
  - Restrições aplicáveis somente por votação da governança.

As [premissas](doc/premissas.md), [macroprocessos](doc/macroprocessos.md) e requisitos da gen02 estão documentados na pasta [`doc`](doc).

Vale salientar, entretanto, que, mesmo após a implantação da gen02, alguns dos *smart contracts* da gen01 seguirão sendo usados, como os *smart contracts* "*proxies*" [`AccountIngress`](../gen01/contracts/AccountIngress.sol) e [`NodeIngress`](../gen01/contracts/NodeIngress.sol) e o *smart contract* que define as contas de administração global da rede (administradores master) [Admin](../gen01/contracts/Admin.sol).


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

Para executar os cenários de teste automatizados:

```shell
npm test
```

**Observação**: Os testes são baseados em cenários, descritos **em linguagem natural**, utilizando a sintaxe [Gherkin](https://cucumber.io/docs/gherkin/). Os cenários podem ser encontrados na pasta [features](features).

Para executar testes unitários:

```shell
npm run test-unit
```


### Debug


#### Cucumber

https://github.com/cucumber/cucumber-js/blob/main/docs/debugging.md

Ajustar variável de ambiente `DEBUG=cucumber`


#### Hardhat

https://hardhat.org/hardhat-runner/docs/troubleshooting/verbose-logging

Ajustar variável de ambiente `HARDHAT_VERBOSE=true`


#### Log nos *smart contracts*

O Hardhat permite utilizar função de log na console, de forma análoga ao Javascript (ver referência ao final do README).

Exemplo:
```
import "hardhat/console.sol";

...

console.log("Parametros %s e %s", p1, p2);
```

**ATENÇÃO**: Esse recurso deve ser usado apenas em testes locais, de forma temporária. Tal recurso **não** pode ser usado para utilização efetiva no código final. **Remova quaisquer referências do tipo antes de fazer commit do código**.


### Auditoria

Os *smart contracts* podem sofrer auditoria através de ferramentas específicas. Veja o documento [auditoria.md](auditoria.md) para mais detalhes.


### Implantação em ambiente local

As seções abaixo descrevem os procedimentos para instalação da gen02 em ambiente local, seja no Hardhat ou seja no Besu.

A implantação no Hardhat contempla processo mais simples, permitindo apenas testes diretos dos *smart contracts* da gen02.

Já a implantação no Besu requer um processo mais complexo, porém permite testes mais elaborados, contemplando testes do procedimento de migração da gen01 para a gen02 (ver seção adiante) e também testes para migração para futuras gerações de permissionamento e governança.


#### Implantação Local no Hardhat

1. Inicie o Hardhat:

```shell
npx hardhat node
```

2. Abra outro terminal/console.

3. Defina a variável de ambiente `CONFIG_PARAMETERS` contendo o caminho do arquivo com os parâmetros de configuração. Para o caso de implantação local no Hardhat, o arquivo [`deploy/parameters-hardhat.json`](deploy/parameters-hardhat.json) já foi preparado.

O ajuste da variável de ambiente pode ser feito via arquivo `.env` ou ajustando o valor diretamente no terminal:

```shell
set CONFIG_PARAMETERS=deploy/parameters-hardhat.json
```

4. Implante o contrato *mock* de [`AdminProxy`](contracts/AdminProxy.sol):

```shell
npm run hardhat-deploy-admin-mock
```

Ao final da implantação, guarde o endereço onde foi implantado o contrato `AdminMock`:

```
Implantando AdminMock
 AdminMock implantado no endereço 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

**Observação**: Para efeitos de teste local da gen02 no Hardhat, não é necessário implantar a gen01. Mas é necessário ter um contrato de `AdminProxy`. Por isso esse mock se faz necessário.

5. Copie o endereço do contrato `AdminMock` no arquivo [`deploy/parameters-hardhat.json`](deploy/parameters-hardhat.json), no parâmetro `adminAddress`:

```
{
    "adminAddress": "0x5FbDB2315678afecb367f032d93F642f64180aa3
    ...
}
```

6. Implante os contratos de permissionamento:

```shell
npm run hardhat-deploy-gen02
```


#### Implantação Local no Besu

Este projeto já contém pronta a configuração de um nó Besu validator. Para entender como esse nó foi preparado e funciona localmente, veja o documento [besu.md](../besu.md).

1. Inicie o Besu:

```shell
besu --config-file besu/config.toml
```

**Observação**: Para que o comando acima funcione, é necessário já ter o Besu e JDK compatível instalados e devidamente configurados no *path* do terminal/console.

2. Abra outro terminal/console.

3. Defina as seguintes variáveis de ambiente:
   1. `CONFIG_PARAMETERS`: Caminho do arquivo com os parâmetros de configuração. Para o caso de implantação local no Besu, o arquivo [`deploy/parameters-local.json`](deploy/parameters-local.json) já foi preparado.
   2. `ACCOUNT_ADDRESS`: Endereço da conta a ser usada para envio de transações.
   3. `PRIVATE_KEY`: Chave privada da conta a ser usada para envio de transações.
   4. `ALT_PRIVATE_KEYS`: **Opcional**. Lista com chaves privadas alternativas, separadas por vírgulas, que podem ser usadas em scripts para simular o envio de transações por outras contas.

O ajuste das variáveis de ambiente pode ser feito via arquivo `.env` ou ajustando o valor diretamente no terminal. Exemplo:

```shell
set CONFIG_PARAMETERS=deploy/parameters-local.json
set ACCOUNT_ADDRESS=0x71bE63f3384f5fb98995898A86B02Fb2426c5788
set PRIVATE_KEY=0x701b615bbdfb9de65240bc28bd21bbc0d996645a3dd57e7b12bc2bdf6f192c82
```

4. A gen02 foi feita para trabalhar com base em contratos da gen01. Portanto, algumas dependências são necessárias para que funcione corretamente. Nesse ponto, deve-se optar por:
   1. Implantar e utilizar a gen01 por completo (sendo que os contratos de [`NodeIngress`](../gen01/contracts/NodeIngress.sol) e [`AccountIngress`](../gen01/contracts/AccountIngress.sol) da gen01 já são implantados automaticamente via arquivo [genesis](../besu/genesis.json)). Nesse caso, vá para o passo 5.
   2. Implantar e utilizar o contrato *mock* de `AdminProxy`. Nesse caso, vá para o passo 6.


5. **Caso vá utilizar a gen01**, veja o procedimento de implantação no documento [README.md](../gen01/README.md) do projeto da gen01.

Ao final da implantação, guarde o endereço onde foi implantado o contrato `Admin`:

```
Validation step finished
   > Admin contract deployed with address = 0x72bb9c7ffbE2Ed234e53bc64862DdA6d9fFF333b
```
   
6. **Caso NÃO vá utilizar a gen01**, implante o contrato *mock* de [`AdminProxy`](contracts/AdminProxy.sol):

```shell
npm run local-deploy-admin-mock
```

Ao final da implantação, guarde o endereço onde foi implantado o contrato `AdminMock`:

```
Implantando AdminMock
 AdminMock implantado no endereço 0x5FbDB2315678afecb367f032d93F642f64180aa3
```

7. Copie o endereço do contrato de `Admin` ou `AdminMock` no arquivo [`deploy/parameters-local.json`](deploy/parameters-local.json), no parâmetro `adminAddress`:

```
{
    "adminAddress": "0x5FbDB2315678afecb367f032d93F642f64180aa3
    ...
}
```

8. Implante os contratos da gen02:

```shell
npm run local-deploy-gen02
```

9. Ao final da implantação, guarde os endereços dos contratos de `OrganizationImpl`, `AccountRulesV2Impl`, `NodeRulesV2Impl` e `Governance`:

```
Implantando smart contract de gestão de organizações
 OrganizationImpl implantado no endereço 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
Implantando smart contract de gestão de contas
 AccountRulesV2Impl implantado no endereço 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
Implantando smart contract de gestão de nós
 NodeRulesV2Impl implantado no endereço 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
Implantando smart contract de governança
 Governance implantado no endereço 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
```

Esses endereços serão necessários para chamadas aos *smart contracts* da gen02, por exemplo, através dos [scripts](https://github.com/RBBNet/scripts-permissionamento) ou [DApp](https://github.com/RBBNet/dapp-permissionamento) de permissionamento


## Implantação em ambientes produtivos


### Implantação na Rede Lab

1. Certifique-se que o projeto está com os fontes atualizados:
```shell
git pull
git status
```

2. Verifique as dependências:
```shell
npm install
```

3. Verifique se os contratos estão compilados e os testes estão passando:
```shell
npm run compile
npm run test-unit
npm test
```

4. Verifique os parâmetros de implantação no arquivo [`deploy/parameters-lab.json`](deploy/parameters-lab.json).
   1. Verifique o endereço do contrato `Admin`.
   2. Verifique as organizações.
   3. Verifique os endereços dos administradores globais. E verifique se **a ordem dos endereços corresponde à ordem das organizações**.

5. Ajuste as variáveis de ambiente. Isso pode ser feito via arquivo `.env` ou ajustando o valor diretamente no terminal. Exemplo:
```shell
set CONFIG_PARAMETERS=deploy/parameters-lab.json
set ACCOUNT_ADDRESS=0x........................................
set PRIVATE_KEY=0x................................................................
```

6. Verifique no arquivo [`hardhat.config.js`](hardhat.config.js) se a url da rede `lab_besu` está correto:
```json
    lab_besu: {
      url: "http://127.0.0.1:8545",
      chainId: 648629,
      accounts: privateKeys,
      from: accountAddress
    },
```

7. Implante os contratos da gen02:
```shell
npm run lab-deploy-gen02
```

Ao final da implantação, guarde os endereços dos contratos de `OrganizationImpl`, `AccountRulesV2Impl`, `NodeRulesV2Impl` e `Governance`:

```
Implantando smart contract de gestão de organizações
 OrganizationImpl implantado no endereço 0x0000000000000000000000000000000000000000
Implantando smart contract de gestão de contas
 AccountRulesV2Impl implantado no endereço 0x0000000000000000000000000000000000000000
Implantando smart contract de gestão de nós
 NodeRulesV2Impl implantado no endereço 0x0000000000000000000000000000000000000000
Implantando smart contract de governança
 Governance implantado no endereço 0x0000000000000000000000000000000000000000
```

8. Documente os endereços dos *smart contracts* da gen02 no GitHub no documento [`contratos.md`](https://github.com/RBBNet/participantes/blob/main/lab/contratos.md).


### Implantação na Rede Piloto

1. Certifique-se que o projeto está com os fontes atualizados:
```shell
git pull
git status
```

2. Verifique as dependências:
```shell
npm install
```

3. Verifique se os contratos estão compilados e os testes estão passando:
```shell
npm run compile
npm run test-unit
npm test
```

4. Verifique os parâmetros de implantação no arquivo [`deploy/parameters-piloto.json`](deploy/parameters-piloto.json).
   1. Verifique o endereço do contrato `Admin`.
   2. Verifique as organizações.
   3. Verifique os endereços dos administradores globais. E verifique se **a ordem dos endereços corresponde à ordem das organizações**.

5. Ajuste as variáveis de ambiente. Isso pode ser feito via arquivo `.env` ou ajustando o valor diretamente no terminal. Exemplo:
```shell
set CONFIG_PARAMETERS=deploy/parameters-piloto.json
set ACCOUNT_ADDRESS=0x........................................
set PRIVATE_KEY=0x................................................................
```

6. Verifique no arquivo [`hardhat.config.js`](hardhat.config.js) se a url da rede `piloto_besu` está correto:
```json
    piloto_besu: {
      url: "http://127.0.0.1:8545",
      chainId: 12120014,
      accounts: privateKeys,
      from: accountAddress
    }
```

7. Implante os contratos da gen02:
```shell
npm run piloto-deploy-gen02
```

Ao final da implantação, guarde os endereços dos contratos de `OrganizationImpl`, `AccountRulesV2Impl`, `NodeRulesV2Impl` e `Governance`:

```
Implantando smart contract de gestão de organizações
 OrganizationImpl implantado no endereço 0x0000000000000000000000000000000000000000
Implantando smart contract de gestão de contas
 AccountRulesV2Impl implantado no endereço 0x0000000000000000000000000000000000000000
Implantando smart contract de gestão de nós
 NodeRulesV2Impl implantado no endereço 0x0000000000000000000000000000000000000000
Implantando smart contract de governança
 Governance implantado no endereço 0x0000000000000000000000000000000000000000
```

8. Documente os endereços dos *smart contracts* da gen02 no GitHub no documento [`contratos.md`](https://github.com/RBBNet/participantes/blob/main/piloto/contratos.md).


## Migração da gen01 para a gen02:

O procedimento recomendado de implantação da gen01 e posterior migração da gen01 para a gen02 está descrito na [documentação da gen02](doc/implantacao-migracao-gen02.md).


## Referências

- [HardHat](https://hardhat.org/hardhat-runner/docs/getting-started)
- [Creating Ingnition Modules](https://hardhat.org/ignition/docs/guides/creating-modules)
- [Deploying your contracts](https://hardhat.org/hardhat-runner/docs/guides/deploying)
- [Deploying a module](https://hardhat.org/ignition/docs/guides/deploy)
- [Hardhat Network](https://hardhat.org/hardhat-network/docs/overview)
- [hardhat-ethers helpers](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers#helpers)
- [Testing contracts](https://hardhat.org/hardhat-runner/docs/guides/test-contracts)
- [Debugging with Hardhat Network](https://hardhat.org/tutorial/debugging-with-hardhat-network)
  - console.log [overview](https://hardhat.org/hardhat-network/docs/overview#console.log)
  - console.log [reference](https://hardhat.org/hardhat-network/docs/reference#console.log)
- [Cucumber JS](https://github.com/cucumber/cucumber-js)
- [Gherkin Syntax](https://cucumber.io/docs/gherkin/)
- [Hardhat-Ethers](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers)
- [Ethers API](https://docs.ethers.org/v6/single-page/#api)
- Mocha
  - [Mocha](https://mochajs.org/)
  - [Assertions](https://mochajs.org/#assertions)
- Node.js
  - [Node.js](https://nodejs.org/)
  - [Assert](https://nodejs.org/api/assert.html)
- [Role-Based Access Control](https://docs.openzeppelin.com/contracts/2.x/access-control#role-based-access-control)
- Foundry
  - [Foundry](https://github.com/foundry-rs/foundry)
  - [Foundry Book](https://book.getfoundry.sh/)