# Macroprocessos da RBB

# Entrada de uma nova organização

Procedimento:
1. Nova organização cria as chaves para uma nova conta de Administrador Global.
2. Administrador Global (de qualquer organização) cria proposta para votação de:
   1. Inclusão de organização
   2. Inclusão de Administrador Global da nova organização, com o endereço gerado
   3. Inclusão de nós para a nova organização
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza novos cadastros.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Saída de uma organização

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para votação de exclusão da organização.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza a exclusão da organização.
4. Todas as contas e nós vinculados tornam-se intrinsecamente inativos.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Cadastro de novo Administrador Global

Procedimento:
1. Organização do novo Administrador Global gera par de chaves.
2. Administrador Global (de qualquer organização) cria proposta para votação do cadastro do novo Administrador Global para a referida organização, informando novo endereço gerado e sua organização.
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza cadastro.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Exclusão de Administrador Global

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para votação da exclusão de um Administrador Global, informando o respectivo endereço.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza exclusão.

**Observação**: **Não** é possível excluir uma conta caso ela seja a única conta de Administrador Global de uma organização. Caso se deseje realmente excluir esse único Administrador Global, antes deve-se cadastrar um novo Administrador Global. Ver o macroprocesso a seguir.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Perda de chave privada de Administrador Global / "Substituição" de Administrador Global

Procedimento:
1. Organização que perdeu a chave privada gera novo par de chaves.
2. Outro Administrador Global (de qualquer organização) cria proposta para votação de:
   1. Cadastro de novo Administrador Global para a referida organização, informando novo endereço gerado
   2. Exclusão do Administrador Global cuja chave foi perdida
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza a "substituição" de contas.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Restrição de acesso a *smart contract*

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para restringir acesso de *smart contract*, informando o endereço do contrato e eventuais contas que possam realizar o acesso restrito.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança realiza a restrição de acesso.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Remoção de restrição de acesso a *smart contract*

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para remover restrição de acesso a *smart contract*, informando o endereço do contrato.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança remove a restrição de acesso.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Cancelamento de uma proposta

Procedimento:
1. Administrador Global (de qualquer organização) cria proposta para cancelar uma outra proposta já existente, informando o identificador dessa outra proposta e o motivo do cancelamento.
2. Organizações votam para aprovar a proposta.
3. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança cancela a outra proposta, impedindo-a de receber votos e ser executada.

Há um [cenário de teste automatizado](../features/macroprocesses.feature) para esse macroprocesso.


# Implantação da segunda geração de permissionamento

Ver documento ["Implantação e migração para a segunda geração (gen02) de permissionamento"](implantacao-migracao-gen02.md).


# Implantação de novo permissionamento (terceira geração em diante)

De acordo com a implantação da segunda geração de permissionamento, somente o *smart contract* de governança/aplicação conseguirá realizar chamadas ao `NodeIngress` e ao `AccountIngress` para reponteirar o permissionamento.

Procedimento:
1. Novo(s) *smart contract(s)* de permissionamento é(são) implantado(s).
2. Administrador Global (de qualquer organização) cria proposta para chamar as funções de reponteiramento desejadas (`NodeIngress` / `AccountIngress`).
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. O reponteiramento é realizado.

Este procedimento pode ser testado através do script [migrate-to-gen03-mock.js](../deploy/migrate-to-gen03-mock.js).


# Implantação de novo mecanismo de governança/votação

Procedimento:
1. Novo *smart contract* de governança/votação é implantado.
2. Administrador Global (de qualquer organização) cria proposta para adicionar o novo *smart contract* como Administrador Master
3. Organizações votam para aprovar a proposta.
4. Administrador Global (de qualquer organização) executa a proposta aprovada.
   1. Governança configura novo *smart contract* como Administrador Master.
5. Novo *smart contract* deve ser acionado, conforme suas regras de funcionamento, para remover o *smart contract* da segunda geração como Administrador Master.

Este procedimento pode ser testado através do script [migrate-governance-mock.js](../deploy/migrate-governance-mock.js).
**Observação**: Este procedimento foi testado tendo-se a gen02 em vigor. **Não** foi realizado teste de migração da governança com uma geração diferente (Ex.: mock de gen03) de permissionamento.