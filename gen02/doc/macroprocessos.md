# Macroprocessos da RBB

# Entrada de uma nova organização

Procedimento:
- Nova organização cria as chaves para uma nova conta de Administrador Global.
- Administrador Global (de qualquer organização) cria proposta para votação de:
  - Inclusão de organização
  - Inclusão de Administrador Global da nova organização, com o endereço gerado
- Organizações votam para aprovar a proposta.
- Governança realiza novos cadastros.


# Saída de uma organização

Procedimento:
- Administrador Global (de qualquer organização) cria proposta para votação de exclusão da organização.
- Organizações votam para aprovar a proposta.
- Governança realiza a exclusão da organização.
- Todas as contas e nós vinculados tornam-se intrinsecamente inativos.


# Perda de chave privada de Administrador Global

Procedimento:
- Organização que perdeu a chave privada gera novo par de chaves.
- Outro Administrador Global (de qualquer organização) cria proposta para votação de:
  - Cadastro de novo Administrador Global para a referida organização, informando novo endereço gerado
  - Exclusão do Administrador Global cuja chave foi perdida
- Organizações votam para aprovar a proposta.
- Governança realiza a "substituição" de contas.


# Implantação da segunda geração de permissionamento

**Observação**: No contexto deste macroprocesso, deve-se entender o termo **Administrador Master** como uma conta cadastrada no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento. E o termo **Administrador Global** deve ser entendido como uma conta cadastrada no *smart contract* [`AccountRulesV2`](../contracts/AccountRulesV2.sol) da **segunda geração** do permissionamento, com o perfil de acesso de gestão global da RBB.

Procedimento:
- Organizações devem criar chaves para suas contas de Administradores Globais.
- Algum partícipe implanta smart contracts de: organizações; contas; nós; e governança/votação.
  - São configuradas as referências entre os *smart contracts*.
  - São pré-cadastradas:
    - Organizações participantes (necessário para as que têm nó).
    - Um único Administrador Global para cada organização (outros Administradores Globais podem ser adicionados posteriormente).
  - ***Smart contract* de governança é cadastrado como Administrador Master.**
- Administradores Globais verificam e complementam cadastros de suas próprias organizações:
  - Novas contas podem ser cadastradas.
  - Os nós das organizações **têm** que ser cadastrados.
  - **Este passo é essencial antes do reponteiramento do permissionamento.**
- Caso necessário, novos Administradores Globais podem ser cadastrados por um Administrador Master:
  - Pode-se já usar o *smart contract* de governança (que já foi cadastrado como Administrador Master) e fazer-se uma proposta/votação; ou
  - Um outro Administrador Master qualquer pode realizar o cadastro.
- Administrador Master realiza reponteiramento do *smart contract* de regras (rules) de nós (`NodeIngress`) para o novo *smart contract* de gestão nós.
- Administrador Master realiza reponteiramento do *smart contract* de regras (rules) de contas (`AccountIngress`) para o novo *smart contract* de gestão de contas.
- **As regras de Administrador Master permanecerão inalteradas**, sendo administradas através de uma lista de endereços no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento.
  - Só estes Administradores Master podem realizar o reponteiramento.
  - Só estes Administradores Master poderão executar certas funções dos *smart contracts* da segunda geração.
- Administrador Master cadastra *smart contract* de governança/votação como Administrador Master.
- Um administrador Global (de qualquer organização) cria proposta para remover todas as demais contas Administrador Master, deixando ativa apenas a conta do *smart contract* de governança/votação.
  - **Observação**: Um Administrador Master não pode remover a si mesmo.
- Organizações votam para aprovar a proposta.
- Um Administrador Global (de qualquer organização) executa a proposta aprovada.
  - Nesse momento, todas as demais contas Administrador Master são removidas.
  - Dessa forma, para todos os efeitos, após a aprovaçao da proposta, só o novo *smart contract* de governança/votação será Administrador Master (no conceito da primeira geração do permissionamento) e, portanto, só ele pode poderá autorizar um novo reponteiramento (através de votação).


# Implantação de novo permissionamento (terceira geração em diante)

De acordo com a implantação da segunda geração de permissionamento, somente o *smart contract* de governança/aplicação conseguirá realizar chamadas ao `NodeIngress` e ao `AccountIngress` para reponteirar o permissionamento.

Procedimento:
- Novo(s) *smart contract(s)* de permissionamento é(são) implantado(s).
- Administrador Global (de qualquer organização) cria proposta para chamar as funções de reponteiramento desejadas (`NodeIngress` / `AccountIngress`).
- Organizações votam para aprovar a proposta.
- O reponteiramento é realizado.


# Implantação de novo mecanismo de governança/votação

Procedimento:
- Novo *smart contract* de governança/votação é implantado.
- Administrador Global (de qualquer organização) cria proposta para adicionar o novo *smart contract* como Administrador Master
- Organizações votam para aprovar a proposta.
- Novo *smart contract* é configurado como Administrador Master.
- Novo *smart contract* deve ser acionado, conforme suas regras de funcionamento, para remover o *smart contract* da segunda geração como Administrador Master.