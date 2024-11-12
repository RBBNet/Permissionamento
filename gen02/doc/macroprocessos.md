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

**Observação**: No contexto deste macroprocesso, deve-se entender o termo **Admin** como uma conta cadastrada no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento. E o termo **Administrador Global** deve ser entendido como uma conta cadastrada no *smart contract* [`AccountRulesV2`](../contracts/AccountRulesV2.sol) da **segunda geração** do permissionamento, com o perfil de acesso de gestão global da RBB.

Procedimento:
- Organizações devem criar chaves para suas contas de administradores globais.
- Admin implanta smart contracts de: organizações; contas; nós; e governança/votação.
- Admin configura ligações entre os *smart contracts*.
- Admin pré-cadastra e ativa:
  - Organizações participantes (necessário para as que têm nó)
  - Seus Administradores Globais
  - Seus nós
- Admin finaliza implantação.
- Administradores Globais verificam cadastros e, havendo necessidade, cadastram demais contas e nós necessários.
  - Eventuais ajustes podem ser feitos, já respeitando as novas regras de permissionamento (ainda que o reponteiramento ainda não tenha sido feito neste momento).
  - Ajustes locais podem ser feitos diretamente pelos Administradores das organizações.
  - Votações podem já ser necessárias, caso se deseje fazer algum ajuste global.
  - **Este passo é essencial antes do reponteiramento do permissionamento.**
- Admin realiza reponteiramento do *smart contract* de regras (rules) de nós (`NodeIngress`) para o novo *smart contract* de nós.
- Admin realiza reponteiramento do *smart contract* de regras (rules) de contas (`AccountIngress`) para o novo *smart contract* de contas. 
- **As regras de Admin permanecem inalteradas**, tanto para nós como para contas, sendo administradas através de uma lista de endereços no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento.
- Admin cadastra *smart contract* de governança/votação como Admin.
- Administrador Global (de qualquer organização) cria proposta para remover todas as demais contas Admin, deixando ativa apenas a conta do *smart contract* de governança/votação.
- Organizações votam para aprovar a proposta.
- Todas as demais contas Admin são removidas.
  - Dessa forma, para todos os efeitos, após a aprovaçao da proposta, só o novo *smart contract* de governança/votação será Admin (no conceito da primeira geração do permissionamento) e, portanto, só ele pode poderá autorizar um novo reponteiramento (através de votação).


# Implantação de novo permissionamento (terceira geração em diante)

Pelo macroprocesso acima (de implantação da segunda geração de permissionamento), somente o *smart contract* de governança/aplicação conseguirá realizar chamadas ao `NodeIngress` e ao `AccountIngress` para reponteirar o permissionamento.

Procedimento:
- Novo(s) *smart contract(s)* de permissionamento é(são) implantado(s).
- Administrador Global (de qualquer organização) cria proposta para chamar as funções de reponteiramento desejadas (`NodeIngress` / `AccountIngress`).
- Organizações votam para aprovar a proposta.
- O reponteiramento é realizado.


# Implantação de novo mecanismo de governança/votação

Procedimento:
- Novo *smart contract* de votação é implantado.
- Administrador Global (de qualquer organização) cria proposta para:
  - Adicionar o novo *smart contract* como Admin
  - Remover o *smart contract* que se deseja substituir como Admin
- Organizações votam para aprovar a proposta.
- Novo mecanismo/*smart contract* é configurado.
