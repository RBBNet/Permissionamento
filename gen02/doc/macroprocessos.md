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
2. Administrador Master implanta smart contracts de: organizações; contas; nós; e governança/votação.
   1. São configuradas as referências entre os *smart contracts*.
   2. São pré-cadastradas:
      1. Organizações participantes (necessário para as que têm nó).
      2. Um único Administrador Global para cada organização (outros Administradores Globais podem ser adicionados posteriormente).
   3. ***Smart contract* de governança é cadastrado como Administrador Master.**
3. Administradores Globais verificam e complementam cadastros de suas próprias organizações:
   1. Novas contas podem ser cadastradas.
   2. Os nós das organizações **têm** que ser cadastrados.
   - **Este passo é essencial antes do reponteiramento do permissionamento.**
4. Caso necessário, novos Administradores Globais podem ser cadastrados:
   - Pode-se já usar o *smart contract* de governança (que já foi cadastrado como Administrador Master) e fazer-se uma proposta/votação; ou
   - Um Administrador Master qualquer pode realizar o cadastro.
5. Administrador Master realiza reponteiramento dos *smart contracts* de regras (rules)
   1. Reponteiramento das regras de nós (`NodeIngress`) para o novo *smart contract* de gestão nós.
   2. Reponteiramento das regras de contas (`AccountIngress`) para o novo *smart contract* de gestão de contas.
- **As regras de Administrador Master permanecerão inalteradas**, sendo administradas através de uma lista de endereços no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento.
   - Só estes Administradores Master podem realizar o reponteiramento.
   - Só estes Administradores Master poderão executar certas funções dos *smart contracts* da segunda geração.
6. Um administrador Global (de qualquer organização) cria proposta para remover todas as demais contas Administrador Master, deixando ativa apenas a conta do *smart contract* de governança/votação.
   - **Observação**: Um Administrador Master não pode remover a si mesmo, por isso a necessidade de haver a execução da exclusão via Governança.
7. Organizações votam para aprovar a proposta.
8. Um Administrador Global (de qualquer organização) executa a proposta aprovada.
   - Nesse momento, todas as demais contas Administrador Master são removidas.
   - Dessa forma, para todos os efeitos, após a aprovaçao da proposta, só o novo *smart contract* de governança/votação será Administrador Master (no conceito da primeira geração do permissionamento) e, portanto, só ele pode poderá autorizar um novo reponteiramento (através de votação).

O passo 2 é implementado pelo script [deploy-gen02.js](../deploy/deploy-gen02.js).

O passo 5 é implementado pelo script [migrate-to-gen02.js](../deploy/migrate-to-gen02.js).


# Implantação de novo permissionamento (terceira geração em diante)

De acordo com a implantação da segunda geração de permissionamento, somente o *smart contract* de governança/aplicação conseguirá realizar chamadas ao `NodeIngress` e ao `AccountIngress` para reponteirar o permissionamento.

Procedimento:
1. Novo(s) *smart contract(s)* de permissionamento é(são) implantado(s).
2. Administrador Global (de qualquer organização) cria proposta para chamar as funções de reponteiramento desejadas (`NodeIngress` / `AccountIngress`).
3. Organizações votam para aprovar a proposta.
4. O reponteiramento é realizado.


# Implantação de novo mecanismo de governança/votação

Procedimento:
1. Novo *smart contract* de governança/votação é implantado.
2. Administrador Global (de qualquer organização) cria proposta para adicionar o novo *smart contract* como Administrador Master
3. Organizações votam para aprovar a proposta.
4. Novo *smart contract* é configurado como Administrador Master.
5. Novo *smart contract* deve ser acionado, conforme suas regras de funcionamento, para remover o *smart contract* da segunda geração como Administrador Master.