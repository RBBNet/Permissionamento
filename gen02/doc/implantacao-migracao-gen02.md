# Implantação e migração para a segunda geração (gen02) de permissionamento

No contexto deste documento, deve-se entender os termos:
- **Administrador Master** como uma conta cadastrada no *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da **primeira geração** do permissionamento.
- **Administrador Global** como uma conta cadastrada no *smart contract* [`AccountRulesV2`](../contracts/AccountRulesV2.sol) da **segunda geração** do permissionamento, com o perfil de acesso de gestão global da RBB.


## Pré-requisitos

1. As organizações deverão criar chaves para suas contas de Administradores Globais.
   - **As chaves privadas deverão ser mantidas com alto rigor de segurança**.
   - Cada organização poderá usar as ferramentas e recursos que acharem mais apropriadas para gerar e manter as chaves privadas, levando-se em conta as restrições de segurança.

2. Administrador Master permissionará as novas contas de Administradores Globais **na gen01 como contas transacionais**.
   - Estas contas **não** deverão ser permissionadas como Administradores Master.
   - Este permissionamento é necessário para que estes administradores possam enviar votos (para aprovação de propostas) ainda com o permissionamento de gen01 valendo.
   - O BNDES executará esse passo, utilizando suas ferramentas de gestão do permissionamento da gen01.

## Implantação da gen02 e permissionamentos iniciais

3. Implantação dos *smart contracts* da gen02: `Organization`, `AccountRulesV2Impl`, `NodeRulesV2Impl` e `Governance`.
   - Serão pré-cadastradas:
     - As organizações participantes que possuem nós.
     - Um único Administrador Global para cada organização (outros Administradores Globais poderão ser adicionados posteriormente).
   - O BNDES realizará a implantação da gen02, através de uma de suas contas permissionadas na gen01.

4. Administrador Master designará governança como novo Administrador Master:
   - ***Smart contract* de governança (`Governance`) será cadastrado como Administrador Master.**
     - Apenas um Administrador Master pode adicionar um outro Administrador Master.
   - O BNDES executará esse passo, utilizando suas ferramentas de gestão do permissionamento da gen01, informando o endereço do *smart contract* de governança conforme obtido na implantação do passo 3.


## Permissionamentos adicionais

5. Administradores Globais verificarão e complementarão os permissionamentos de suas próprias organizações:
   - **Este passo é essencial antes do reponteiramento do permissionamento.**
   - Os nós das organizações **terão** que ser cadastrados.
   - Novas contas poderão ser cadastradas.
   - Para essas atividades de permissionamento, as organizações poderão usar os [scripts](https://github.com/RBBNet/scripts-permissionamento) ou o [DApp](https://github.com/RBBNet/dapp-permissionamento) de permissionamento, utilizando versões compatíveis com a gen02.

6. **OPCIONAL**: Caso necessário, novos Administradores Globais poderão ser cadastrados.
   - As organizações que desejarem cadastrar novos Administradores Globais deverão se manifestar e criar novas chaves privadas para estes administradores.
     - **As chaves privadas deverão ser mantidas com alto rigor de segurança**.
   - O BNDES criará proposta para cadastramento dos novos Administradores Globais.
   - Organizações participantes votarão para aprovar a proposta.
   - O BNDES executará a proposta aprovada.
   - Para as ações de governança, o BNDES utilizará suas ferramentas de gestão do permissionamento da gen02.
   - Para envio de votos, as organizações poderão usar os [scripts](https://github.com/RBBNet/scripts-permissionamento) ou o [DApp](https://github.com/RBBNet/dapp-permissionamento) de permissionamento, utilizando versões compatíveis com a gen02.

7. Cadastramento das organizações que não têm nó implantado.
   - As organizações serão cadastradas de forma a dar transparência ao público sobre quem faz parte da RBB.
     - As organizações serão cadastradas **sem** Administrador Global e **sem** direito a voto, mesmo que sejam partícipes associados.
   - Este passo poderá ser feito paralelamente ao passo anterior, caso necessário, sem prejuízos.
   - O BNDES criará proposta para cadastramento destas organizações.
   - Organizações participantes votarão para aprovar a proposta.
   - O BNDES executará a proposta aprovada.
   - Para as ações de governança, o BNDES utilizará suas ferramentas de gestão do permissionamento da gen02.
   - Para envio de votos, as organizações poderão usar os [scripts](https://github.com/RBBNet/scripts-permissionamento) ou o [DApp](https://github.com/RBBNet/dapp-permissionamento) de permissionamento, utilizando versões compatíveis com a gen02.


## Migração para a gen02

8. Reponteiramento dos *smart contracts* de regras de permissionamento (`RULES_CONTRACT`) nos *smart contracts* `Ingress`:
   - O BNDES criará proposta com os seguintes passos:
     - Reponteiramento das regras de permissionamento de nós (`NodeIngress`) para o novo *smart contract* de gestão nós (`NodeRulesV2Impl`).
     - Reponteiramento das regras de permissionamento de contas (`AccountIngress`) para o novo *smart contract* de gestão de contas (`AccountRulesV2Impl`).
   - Organizações participantes votarão para aprovar a proposta.
   - O BNDES executará a proposta aprovada.
   - Para as ações de governança, o BNDES utilizará suas ferramentas de gestão do permissionamento da gen02.
   - Para envio de votos, as organizações poderão usar os [scripts](https://github.com/RBBNet/scripts-permissionamento) ou o [DApp](https://github.com/RBBNet/dapp-permissionamento) de permissionamento, utilizando versões compatíveis com a gen02.

**Observação**: Os *smart contracts* `Ingress` têm dois conjuntos de regras: 1) regras de permissionamento (`RULES_CONTRACT`); e 2) regras de administração para o ponteiramento (`ADMIN_CONTRACT`). **As regras de administração do ponteiramento permanecerão inalteradas**, continuando a serem administradas através da lista de Administradores Master do *smart contract* [`Admin`](../../gen01/contracts/Admin.sol) da gen01. A proposta que será criada modificará apenas as regras de permissionamento.

9. Remoção de todas as contas Administrador Master, deixando ativa apenas a conta do *smart contract* de governança (`Governance`):
   - O BNDES criará proposta com passos para remoção de todos os endereços cadastrados como Administradores Master que não sejam o *smart contract* de governança.
     - Será necessário criar um passo para cada endereço a ser removido.
   - Organizações participantes votarão para aprovar a proposta.
   - O BNDES executará a proposta aprovada.
   - Nesse momento, todas as demais contas Administrador Master são removidas.
   - Dessa forma, para todos os efeitos, após a aprovaçao da proposta, só o novo *smart contract* de governança será Administrador Master e, portanto, só ele pode poderá autorizar um novo reponteiramento (através de votação).
   - Para as ações de governança, o BNDES utilizará suas ferramentas de gestão do permissionamento da gen02.
   - Para envio de votos, as organizações poderão usar os [scripts](https://github.com/RBBNet/scripts-permissionamento) ou o [DApp](https://github.com/RBBNet/dapp-permissionamento) de permissionamento, utilizando versões compatíveis com a gen02.


## Verificações

10. Serão realizadas verificações e diagnósticos sobre o estado do permissionamento *on chain* na rede, de forma a garantir que a gen02 foi aplicada corretamente está plenamente funcional.
