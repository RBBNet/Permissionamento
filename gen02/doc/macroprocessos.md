# Macroprocessos da RBB

# Entrada de uma nova organização

Procedimento:
1. Nova organização cria as chaves para uma nova conta de Administrador Global.
2. Administrador Global (de qualquer organização) cria proposta para votação de:
   1. Inclusão de organização
   2. Inclusão de Administrador Global da nova organização, com o endereço gerado
3. Organizações votam para aprovar a proposta.
4. Governança realiza novos cadastros.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Saída de uma organização

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para votação de exclusão da organização.
2. Organizações votam para aprovar a proposta.
3. Governança realiza a exclusão da organização.
4. Todas as contas e nós vinculados tornam-se intrinsecamente inativos.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Perda de chave privada de Administrador Global

Procedimento:
1. Organização que perdeu a chave privada gera novo par de chaves.
2. Outro Administrador Global (de qualquer organização) cria proposta para votação de:
   1. Cadastro de novo Administrador Global para a referida organização, informando novo endereço gerado
   2. Exclusão do Administrador Global cuja chave foi perdida
3. Organizações votam para aprovar a proposta.
4. Governança realiza a "substituição" de contas.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Implantação da segunda geração de permissionamento

**Observação**: No contexto deste macroprocesso, deve-se entender o termo **Administrador Master** como uma conta cadastrada no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento. E o termo **Administrador Global** deve ser entendido como uma conta cadastrada no *smart contract* [`AccountRulesV2`](../contracts/AccountRulesV2.sol) da **segunda geração** do permissionamento, com o perfil de acesso de gestão global da RBB.

Procedimento:
1. Organizações devem criar chaves para suas contas de Administradores Globais.
   - **As chaves privadas devem ser mantidas com alto rigor de segurança**. 
2. Administrador Master implanta smart contracts de: organizações; contas; nós; e governança/votação.
   1. São configuradas as referências entre os *smart contracts*.
   2. São pré-cadastradas:
      1. Organizações participantes (necessário para as que têm nó).
      2. Um único Administrador Global para cada organização (outros Administradores Globais podem ser adicionados posteriormente).
   3. ***Smart contract* de governança é cadastrado como Administrador Master.**
3. Administradores Globais verificam e complementam cadastros de suas próprias organizações:
   1. Novas contas podem ser cadastradas.
   2. Os nós das organizações **têm** que ser cadastrados.
   3. Testes automatizados para validar o permissionamento de contas (`transactionAllowed()`).
   4. Testes automatizados para validar o permissionamento de nós (`connectionAllowed()`).
   - **Este passo é essencial antes do reponteiramento do permissionamento.**
4. Caso necessário, novos Administradores Globais podem ser cadastrados.
   - Suger-se já usar o *smart contract* de governança (que já foi cadastrado como Administrador Master) e fazer-se proposta(s)/votação(ões) para isso. Dessa forma, já se pode testar e exercitar o mecanismo de governança.
5. Cadastramento das organizações que não têm nó implantado.
   1. Um administrador Global (de qualquer organização) cria proposta para cadastramento das organizações que não têm nó implantado.
   2. Organizações votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização) executa a proposta aprovada.
   - Este passo pode ser feito paralelamente ao passo anterior, caso necessário, sem prejuízos.
   - A ideia de cadastrar essas organizações é para dar transparência ao público sobre quem faz parte da RBB. Ao mesmo tempo, pode-se já testar e exercitar o mecanismo de governança.
   - **Não** é necessário que sejam cadastrados Administradores Globais para estas organizações.
     - Porém, caso algum Administrador Global seja cadastrado, **a chave privada deverá ser mantida com alto rigor de segurança**.
     - Após o cadastramento do primeiro Administrador Global de uma organização, deverá sempre existir ao menos um Administrador Global.
6. Reponteiramento dos *smart contracts* de regras (rules):
   1. Um administrador Global (de qualquer organização) cria proposta com os seguintes passos: 
      1. Reponteiramento das regras de nós (`NodeIngress`) para o novo *smart contract* de gestão nós.
      2. Reponteiramento das regras de contas (`AccountIngress`) para o novo *smart contract* de gestão de contas.
   2. Organizações votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização) executa a proposta aprovada.
- **As regras de Administrador Master permanecerão inalteradas**, sendo administradas através de uma lista de endereços no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento.
 - Só estes Administradores Master podem realizar o reponteiramento.
 - Só estes Administradores Master poderão executar certas funções dos *smart contracts* da segunda geração.
7. Remoção de todas as contas Administrador Master, deixando ativa apenas a conta do *smart contract* de governança/votação:
   1. Um administrador Global (de qualquer organização) cria proposta para remover todas as demais contas de Administrador Master.
      - **Observação**: Um Administrador Master não pode remover a si mesmo, portanto é necessário haver a execução da exclusão via Governança.
   2. Organizações votam para aprovar a proposta.
   3. Um Administrador Global (de qualquer organização) executa a proposta aprovada.
   - Nesse momento, todas as demais contas Administrador Master são removidas.
   - Dessa forma, para todos os efeitos, após a aprovaçao da proposta, só o novo *smart contract* de governança/votação será Administrador Master (no conceito da primeira geração do permissionamento) e, portanto, só ele pode poderá autorizar um novo reponteiramento (através de votação).
   4. Testes de verificação

Implementação:
- Passo 2 - [deploy-gen02.js](../deploy/deploy-gen02.js)
  - Parâmetros:
    - `adminAddress`: Endereço do *smart contract* `Admin` da gen01.
    - `organizations`: Lista de organizações a serem pré-cadastradas.
    - `globalAdmins`: Lista dos endereços a serme pré-cadastrados como Administradores globais das organizações.
    - As listas `organizations` e `globalAdmins` devem estar "sincronizadas". Isto é, o enésimo endereço será o Administrador Global da enésima organização.
- Passo 3:
  - 3.1 - [add-accounts-gen02.js](../deploy/add-accounts-gen02.js)
    - Parâmetros: 
      - `organizationAddress`: Endereço do *smart contract* de `OrganizationImpl`, conforme implantado no passo 2.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `accounts`: Lista de contas a serem cadastradas.
  - 3.2 - [add-nodes-gen02.js](../deploy/add-nodes-gen02.js)
    - Parâmetros: 
      - `organizationAddress`: Endereço do *smart contract* de `OrganizationImpl`, conforme implantado no passo 2.
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `nodeRulesV2Address`: Endereço do *smart contract* de `NodeRulesV2Impl`, conforme implantado no passo 2.
      - `nodes`: Lista de nós a serem cadastrados.
  - 3.3 - [test-accounts-gen02.js](../deploy/test-accounts-gen02.js)
    - Parâmetros: 
      - `accountRulesV2Address`: Endereço do *smart contract* de `AccountRulesV2Impl`, conforme implantado no passo 2.
      - `accounts`: Lista de contas a serem testadas.
  - 3.4 - [test-nodes-gen02.js](../deploy/test-nodes-gen02.js)
    - Parâmetros: 
      - `nodeRulesV2Address`: Endereço do *smart contract* de `NodeRulesV2Impl`, conforme implantado no passo 2.
      - `nodes`: Lista de nós a serem testados.
- Passo 4, caso necessário:
  - [create-proposal-add-global-admins.js] (TODO)
  - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
- Passo 5:
  - 5.1 - [create-proposal-add-new-orgs.js] (TODO)
  - 5.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 5.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
- Passo 6:
  - 6.1 - [create-proposal-mig-gen02.js] (TODO)
  - 6.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 6.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - OBSOLETO - [migrate-to-gen02.js](../deploy/migrate-to-gen02.js) (TODO)
- Passo 7:
  - 7.1 - [create-proposal-remove-admins.js](../deploy/create-proposal-remove-admins.js)
  - 7.2 - [cast-vote.js](../deploy/cast-vote.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser votada e indicação de aprovação ou reprovação.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 7.3 - [execute-proposal.js](../deploy/execute-proposal.js)
    - Parâmetros:
      - `proposal`: Identificador da proposta a ser executada.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.
  - 7.4 - [verify-governance.js](../deploy/verify-governance.js) - Parâmetros: ``, `` e ``
    - Parâmetros:
      - `adminAddress`: Endereço do *smart contract* `Admin` da gen01.
      - `governanceAddress`: Endereço do *smart contract* de `Governance`, conforme implantado no passo 2.

**Observações:
- Os scripts devem ser executados via Hardhat, através dos "scripts" cadastrados na propriedade `scripts` no [package.json](../package.json) deste projeto.
- Deve-se usar o "script" correto de acordo com o ambiente e rede desejadas.
  - Por exemplo, para o ambiente local em rede Besu, usar os scripts `deploy-local-xxx`.
  - As redes previstas estão definidas na propriedade `networks` do arquivo [hardhat.config.js](../hardhat.config.js).
- Os scripts dependem de parâmetros configurados em arquivos JSON.
  - A localização deste arquivo deve estar configurada na variável de ambiente `CONFIG_PARAMETERS`.
  - Alguns arquivos de parâmetros de exemplo já existem na pasta [deploy](../deploy), como por exemplo o [parameters-local.json](../deploy/parameters-local.json).
- A conta com a qual o script será usado, e sua respectiva chave privada, devem ser configuradas nas variáveis de ambiente `ACCOUNT_ADDRESS` e `PRIVATE_KEY`.
  - Cada organização deverá configurar essas variáveis de forma apropriada, com sua conta de Administrador Global (ou Administrador Master, quando for o caso).
- As variáveis de ambiente, caso desejado, podem ser configuradas em arquivo local `.env`, na pasta da `gen02`.


# Implantação de novo permissionamento (terceira geração em diante)

De acordo com a implantação da segunda geração de permissionamento, somente o *smart contract* de governança/aplicação conseguirá realizar chamadas ao `NodeIngress` e ao `AccountIngress` para reponteirar o permissionamento.

Procedimento:
1. Novo(s) *smart contract(s)* de permissionamento é(são) implantado(s).
2. Administrador Global (de qualquer organização) cria proposta para chamar as funções de reponteiramento desejadas (`NodeIngress` / `AccountIngress`).
3. Organizações votam para aprovar a proposta.
4. O reponteiramento é realizado.

Este procedimento pode ser testado através do script [migrate-to-gen03-mock.js](../deploy/migrate-to-gen03-mock.js).


# Implantação de novo mecanismo de governança/votação

Procedimento:
1. Novo *smart contract* de governança/votação é implantado.
2. Administrador Global (de qualquer organização) cria proposta para adicionar o novo *smart contract* como Administrador Master
3. Organizações votam para aprovar a proposta.
4. Novo *smart contract* é configurado como Administrador Master.
5. Novo *smart contract* deve ser acionado, conforme suas regras de funcionamento, para remover o *smart contract* da segunda geração como Administrador Master.

Este procedimento pode ser testado através do script [migrate-governance-mock.js](../deploy/migrate-governance-mock.js).
**Observação**: Este procedimento foi testado tendo-se a gen02 em vigor. **Não** foi realizado teste de migração da governança com uma geração diferente (Ex.: mock de gen03) de permissionamento.