# Adição de nova organização via gen02

Para que uma nova organização possa fazer parte da rede é necessário que ela seja cadastrada e que a ela sejam associados ao menos uma conta de administrador global e os nós que serão inicialmente implantados. Esse documento demonstra como realizar isso, através de proposta de governança, utilizando os [scripts de permissionamento](https://github.com/RBBNet/scripts-permissionamento/).

## Acões necessárias

Conforme mencionado acima, para a adição da nova organização ao permissionamento, é necessário utilizar as seguintes funções da gen02:
- [`Organization.addOrganization(string cnpj, string name, OrganizationType orgType, bool canVote)`](../contracts/Organization.sol#L29)
- [`AccountRulesV2.addAccount(address account, uint orgId, bytes32 roleId, bytes32 dataHash)`](../contracts/AccountRulesV2.sol#L48)
- [`NodeRulesV2.addNode(bytes32 enodeHigh, bytes32 enodeLow, NodeType nodeType, string memory name, uint orgId)`](../contracts/NodeRulesV2.sol#L51)

Porém, todas estas funções são de uso restrito da governança. Isto é, somente podem ser executadas através do *smart contract* [`Governance`](../contracts/Governance.sol), que tem direitos administrativos para tal. Desta forma, faz-se necessário a criação de uma proposta de governança, que, uma vez aprovada pelas organizações partícipes, poderá ser executada e chamar as funções acima.

## Criação de proposta de governança

A criação de uma proposta de governança é feita através da função [`Governance.createProposal(address[] targets, bytes[] calldatas, uint blocksDuration, string description)`](../contracts/Governance.sol#L152).

Os parâmetros necessários para a criação da proposta são:
- `targets`: Array de endereços dos *smart contracts* a serem executados.
- `calldatas`: Array de dados de chamadas (*calldatas*) a funções dos *smart contracts*.
- `blocksDuration`: Quantidade de blocos para a qual a proposta se mantém válida.
- `description`: Texto descritivo da proposta.

A obtenção e preparação dos parâmetros `targets` e `calldatas` não são triviais e, caso sejam feitas de forma manual, são propensas a erro. Portanto, utilizaremos o utilitário [`calldata.js`](https://github.com/RBBNet/scripts-permissionamento/blob/main/calldata.js) dos [scripts de permissionamento](https://github.com/RBBNet/scripts-permissionamento/).

### Passo 1: Cadastro da nova organização

Para cadastro da nova organização, utilizaremos:
```
node calldata.js OrganizationImpl addOrganization <cnpj> <name> <orgType> <canVote>
```

Onde:
- `cnpj`: CNPJ da organização.
- `name`: Nome da organização (qualquer nome desejado).
- `orgType`: Pode ser `Partner`, `Associate` ou `Patron`.
- `canVote`: Pode ser `true` ou `false`.

Exemplo:
```
node calldata.js OrganizationImpl addOrganization 52047458000108 "PLEXOS" Associate true
Chamada para OrganizationImpl.addOrganization 52047458000108,PLEXOS,Associate,true

Target:
0xc1636FcC2627202a9a20aa052884D05343309Eb9

Calldata:
0x21c074b8000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000e35323034373435383030303130380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006504c45584f530000000000000000000000000000000000000000000000000000
```

### Passo 2: Cadastro de administrador global

Para o cadastro do administrador global, utilizaremos:
```
node calldata.js AccountRulesV2Impl addAccount <account> <orgId> <roleId> <dataHash>
```

Onde:
- `account`: Endereço a ser cadastrado.
- `orgId`: Identificador da nova organização. Assume-se que esse identificador corresponderá ao valor de [`OrganizationImpl.idSeed`](../contracts/OrganizationImpl.sol#L12), conforme observado **antes** da execução do passo 1.
- `roleId`: Deve ser `GLOBAL_ADMIN_ROLE` para o administrador global.
- `dataHash`: Deve ser `0x0000000000000000000000000000000000000000000000000000000000000000` para o administrador global.

Exemplo:
```
node calldata.js AccountRulesV2Impl addAccount 0x24F956E90e44e4094c8EFCf7437A9aAdC9614a2f 16 GLOBAL_ADMIN_ROLE 0x0000000000000000000000000000000000000000000000000000000000000000
Chamada para AccountRulesV2Impl.addAccount 0x24F956E90e44e4094c8EFCf7437A9aAdC9614a2f,16,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000

Target:
0x8Fc7cBE1E9c4f60cd7c0C672e8e8d651f9e3D045

Calldata:
0x18aa381000000000000000000000000024f956e90e44e4094c8efcf7437a9aadc9614a2f0000000000000000000000000000000000000000000000000000000000000010d6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f0000000000000000000000000000000000000000000000000000000000000000
```

### Passo 3: Cadastro dos nós

Para o cadastro de cada nó, utilizaremos:
```
node calldata.js NodeRulesV2Impl addNode <enodeHigh> <enodeLow> <nodeType> <name> <orgId>
```

Onde:
- `enodeHigh`: Primeiros 32 bytes da chave pública do nó, precedidos de `0x`.
- `enodeLow`: Últimos 32 bytes da chave pública do nó, precedidos de `0x`.
- `nodeType`: Pode ser `Boot`, `Validator`, `Writer`, `WriterPartner`, `ObserverBoot`, `Observer` ou `Other`
- `name`: Nome descritivo do nó, de acordoo com o [padrão de nomes de nós da RBB](https://github.com/RBBNet/rbb/blob/master/padrao_nomes_nos.md).
- `orgId`: Identificador da nova organização, conforme utilizado no passo 2.

Exemplos:
```
node calldata.js NodeRulesV2Impl addNode 0x3a72fd3f1f02b5c30dbdbbaf115ab64b6ccb9733a3886f7b3f55fb3584204160 0x3a51e0bdcfc8def8b91650ff93c341ee3eb96ecae2b042654d8e8e417855c967 Boot boot01 16
Chamada para NodeRulesV2Impl.addNode 0x3a72fd3f1f02b5c30dbdbbaf115ab64b6ccb9733a3886f7b3f55fb3584204160,0x3a51e0bdcfc8def8b91650ff93c341ee3eb96ecae2b042654d8e8e417855c967,Boot,boot01,16

Target:
0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E

Calldata:
0xa9aab5eb3a72fd3f1f02b5c30dbdbbaf115ab64b6ccb9733a3886f7b3f55fb35842041603a51e0bdcfc8def8b91650ff93c341ee3eb96ecae2b042654d8e8e417855c967000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000006626f6f7430310000000000000000000000000000000000000000000000000000
```

```
node calldata.js NodeRulesV2Impl addNode 0x3d8883914eda1639e47d537112fca74697b6a7190ab3cc4d8ae743d31a112115 0x7822c2b2ec064e785d0d70ef263ca8cb438f2314a23b5036661e6b1ed0793821 Validator validator01 16
Chamada para NodeRulesV2Impl.addNode 0x3d8883914eda1639e47d537112fca74697b6a7190ab3cc4d8ae743d31a112115,0x7822c2b2ec064e785d0d70ef263ca8cb438f2314a23b5036661e6b1ed0793821,Validator,validator01,16

Target:
0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E

Calldata:
0xa9aab5eb3d8883914eda1639e47d537112fca74697b6a7190ab3cc4d8ae743d31a1121157822c2b2ec064e785d0d70ef263ca8cb438f2314a23b5036661e6b1ed0793821000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000b76616c696461746f723031000000000000000000000000000000000000000000
```

```
node calldata.js NodeRulesV2Impl addNode 0x9069453774ff7fbc621dc1a2859f5941715e8e1a3ff909d22575b68fc363584f 0x9ccae6866065dbefaf66c7ff434fc9873b9ebf5d2f525887183f0f525e997ca9 Writer writer01 16
Chamada para NodeRulesV2Impl.addNode 0x9069453774ff7fbc621dc1a2859f5941715e8e1a3ff909d22575b68fc363584f,0x9ccae6866065dbefaf66c7ff434fc9873b9ebf5d2f525887183f0f525e997ca9,Writer,writer01,16

Target:
0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E

Calldata:
0xa9aab5eb9069453774ff7fbc621dc1a2859f5941715e8e1a3ff909d22575b68fc363584f9ccae6866065dbefaf66c7ff434fc9873b9ebf5d2f525887183f0f525e997ca9000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000087772697465723031000000000000000000000000000000000000000000000000
```

```
node calldata.js NodeRulesV2Impl addNode 0xf8a83171b9cf076306c5def4b337da57bb710a84baf66ff842301dd399a935f8 0x570bdcbaa285f77bc4cca9a48408cc970ad43850439b1c6580fe27cd1ba2817d ObserverBoot observer-boot01 16
Chamada para NodeRulesV2Impl.addNode 0xf8a83171b9cf076306c5def4b337da57bb710a84baf66ff842301dd399a935f8,0x570bdcbaa285f77bc4cca9a48408cc970ad43850439b1c6580fe27cd1ba2817d,ObserverBoot,observer-boot01,16

Target:
0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E

Calldata:
0xa9aab5ebf8a83171b9cf076306c5def4b337da57bb710a84baf66ff842301dd399a935f8570bdcbaa285f77bc4cca9a48408cc970ad43850439b1c6580fe27cd1ba2817d000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000f6f627365727665722d626f6f7430310000000000000000000000000000000000
```

### Criando a proposta

Após cada chamada ao utilitário `calldata.js` são retornados um `Target:` e um `Calldata:`, conforme visto nos exemplos. Devemos utiliar esses valores para a criação da proposta com o comando abaixo, que corresponde à chamada `Governance.createProposal()` mencionada anteriormente:
```
node governance.js createProposal [target_1 ... target_N] [calldata_1 ... calldata_N], <blocksDuration>, <description>
```

Onde:
- `target_i`: São os *targets* retornados nos passos anteriores.
- `calldata_i`: São os *calldatas* retornados nos passos anteriores.
- `blocksDuration`: Quantidade de blocos desejada para a criação da proposta. Sugere-se um valor entre `30000` (~33h20min) e `60000` (~66h40min).
- `description`: Texto descritivo da proposta.

Por estarmos lidando com longas cadeias de caracteres para os valores dos parâmetros (principalmente no caso dos *calldatas*), para minimizar a propensão a erros, sugere-se a utilização de variáveis de ambiente para representação dos *targets* e *calldatas*.

Exemplo (valores encurtados para melhor ilustração):

Windows
```
SET T1=0xc1636FcC2627202a9a20aa052884D05343309Eb9
SET T2=0x8Fc7cBE1E9c4f60cd7c0C672e8e8d651f9e3D045
SET T3=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E
SET T4=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E
SET T5=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E
SET T6=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E

SET C1=0x21c074b800000000000000000000000000000000...0000000000000000000000000000000000000000
SET C2=0x18aa381000000000000000000000000024f956e9...0000000000000000000000000000000000000000
SET C3=0xa9aab5eb3a72fd3f1f02b5c30dbdbbaf115ab64b...0000000000000000000000000000000000000000
SET C4=0xa9aab5eb3d8883914eda1639e47d537112fca746...0000000000000000000000000000000000000000
SET C5=0xa9aab5eb9069453774ff7fbc621dc1a2859f5941...0000000000000000000000000000000000000000
SET C6=0xa9aab5ebf8a83171b9cf076306c5def4b337da57...7430310000000000000000000000000000000000

echo node governance.js createProposal [%T1% %T2% %T3% %T4% %T5% %T6%] [%C1% %C2% %C3% %C4% %C5% %C6%] 40000 "Adicionar PLEXOS"
```

Linux
```
T1=0xc1636FcC2627202a9a20aa052884D05343309Eb9
T2=0x8Fc7cBE1E9c4f60cd7c0C672e8e8d651f9e3D045
T3=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E
T4=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E
T5=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E
T6=0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E

C1=0x21c074b800000000000000000000000000000000...0000000000000000000000000000000000000000
C2=0x18aa381000000000000000000000000024f956e9...0000000000000000000000000000000000000000
C3=0xa9aab5eb3a72fd3f1f02b5c30dbdbbaf115ab64b...0000000000000000000000000000000000000000
C4=0xa9aab5eb3d8883914eda1639e47d537112fca746...0000000000000000000000000000000000000000
C5=0xa9aab5eb9069453774ff7fbc621dc1a2859f5941...0000000000000000000000000000000000000000
C6=0xa9aab5ebf8a83171b9cf076306c5def4b337da57...7430310000000000000000000000000000000000

echo node governance.js createProposal [$T1 $T2 $T3 $T4 $T5 $T6] [$C1 $C2 $C3 $C4 $C5 $C6] 40000 "Adicionar PLEXOS"
```

Uma vez que o comando `echo` seja realizado, será exibido na console o comando exato a ser executado via [scripts de permissionamento](https://github.com/RBBNet/scripts-permissionamento/):
```
node governance.js createProposal [0xc1636FcC2627202a9a20aa052884D05343309Eb9 0x8Fc7cBE1E9c4f60cd7c0C672e8e8d651f9e3D045 0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E 0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E 0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E 0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E] [0x21c074b8000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000e35323034373435383030303130380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006504c45584f530000000000000000000000000000000000000000000000000000 0x18aa381000000000000000000000000024f956e90e44e4094c8efcf7437a9aadc9614a2f0000000000000000000000000000000000000000000000000000000000000010d6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f0000000000000000000000000000000000000000000000000000000000000000 0xa9aab5eb3a72fd3f1f02b5c30dbdbbaf115ab64b6ccb9733a3886f7b3f55fb35842041603a51e0bdcfc8def8b91650ff93c341ee3eb96ecae2b042654d8e8e417855c967000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000006626f6f7430310000000000000000000000000000000000000000000000000000 0xa9aab5eb3d8883914eda1639e47d537112fca74697b6a7190ab3cc4d8ae743d31a1121157822c2b2ec064e785d0d70ef263ca8cb438f2314a23b5036661e6b1ed0793821000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000b76616c696461746f723031000000000000000000000000000000000000000000 0xa9aab5eb9069453774ff7fbc621dc1a2859f5941715e8e1a3ff909d22575b68fc363584f9ccae6866065dbefaf66c7ff434fc9873b9ebf5d2f525887183f0f525e997ca9000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000087772697465723031000000000000000000000000000000000000000000000000 0xa9aab5ebf8a83171b9cf076306c5def4b337da57bb710a84baf66ff842301dd399a935f8570bdcbaa285f77bc4cca9a48408cc970ad43850439b1c6580fe27cd1ba2817d000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000f6f627365727665722d626f6f7430310000000000000000000000000000000000] 40000 "Adicionar PLEXOS"
```

Este comando pode ser usado para criação da proposta.

A utilização de variáveis de ambiente é apenas uma sugestão. Caso se deseje, pode-se montar a chamada manualmente, de alguma forma, e utilizá-la normalmente.

## Votação de proposta de governança

Uma vez criada a proposta para a adição da nova organização, as organizações com capacidade de voto deverão se manifestar.

A proposta pode ser consultada com o comando:
```
node governance.js getProposal <proposalId>
```

Onde `proposalId` é o identificador da proposta criada.

Como resultado, tem-se algo como:
```
URL JSON RPC: http://localhost:8545
Network: unknown
Conta em uso: 0x71bE63f3384f5fb98995898A86B02Fb2426c5788

Governance: 0x8Ed5f47E1CBf30de81ea1fab5f678319F35AF667

==================================================
Governance.getProposal(6)
==================================================

Proposta 6:
 Proponent: 1
 Targets:
  0xc1636FcC2627202a9a20aa052884D05343309Eb9 (OrganizationImpl)
  0x8Fc7cBE1E9c4f60cd7c0C672e8e8d651f9e3D045 (AccountRulesV2Impl)
  0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E (NodeRulesV2Impl)
  0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E (NodeRulesV2Impl)
  0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E (NodeRulesV2Impl)
  0x805c4338Aa7D1AeA4aF14F79d03d14Ad815d617E (NodeRulesV2Impl)
 Calldatas:
  0x21c074b8000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000e35323034373435383030303130380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006504c45584f530000000000000000000000000000000000000000000000000000
   addOrganization(52047458000108,PLEXOS,1,true)
  0x18aa381000000000000000000000000024f956e90e44e4094c8efcf7437a9aadc9614a2f0000000000000000000000000000000000000000000000000000000000000010d6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f0000000000000000000000000000000000000000000000000000000000000000
   addAccount(0x24F956E90e44e4094c8EFCf7437A9aAdC9614a2f,16,0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f,0x0000000000000000000000000000000000000000000000000000000000000000)
  0xa9aab5eb3a72fd3f1f02b5c30dbdbbaf115ab64b6ccb9733a3886f7b3f55fb35842041603a51e0bdcfc8def8b91650ff93c341ee3eb96ecae2b042654d8e8e417855c967000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000006626f6f7430310000000000000000000000000000000000000000000000000000
   addNode(0x3a72fd3f1f02b5c30dbdbbaf115ab64b6ccb9733a3886f7b3f55fb3584204160,0x3a51e0bdcfc8def8b91650ff93c341ee3eb96ecae2b042654d8e8e417855c967,0,boot01,16)
  0xa9aab5eb3d8883914eda1639e47d537112fca74697b6a7190ab3cc4d8ae743d31a1121157822c2b2ec064e785d0d70ef263ca8cb438f2314a23b5036661e6b1ed0793821000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000b76616c696461746f723031000000000000000000000000000000000000000000
   addNode(0x3d8883914eda1639e47d537112fca74697b6a7190ab3cc4d8ae743d31a112115,0x7822c2b2ec064e785d0d70ef263ca8cb438f2314a23b5036661e6b1ed0793821,1,validator01,16)
  0xa9aab5eb9069453774ff7fbc621dc1a2859f5941715e8e1a3ff909d22575b68fc363584f9ccae6866065dbefaf66c7ff434fc9873b9ebf5d2f525887183f0f525e997ca9000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000087772697465723031000000000000000000000000000000000000000000000000
   addNode(0x9069453774ff7fbc621dc1a2859f5941715e8e1a3ff909d22575b68fc363584f,0x9ccae6866065dbefaf66c7ff434fc9873b9ebf5d2f525887183f0f525e997ca9,2,writer01,16)
  0xa9aab5ebf8a83171b9cf076306c5def4b337da57bb710a84baf66ff842301dd399a935f8570bdcbaa285f77bc4cca9a48408cc970ad43850439b1c6580fe27cd1ba2817d000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000f6f627365727665722d626f6f7430310000000000000000000000000000000000
   addNode(0xf8a83171b9cf076306c5def4b337da57bb710a84baf66ff842301dd399a935f8,0x570bdcbaa285f77bc4cca9a48408cc970ad43850439b1c6580fe27cd1ba2817d,4,observer-boot01,16)
 Blocks duration: 40000
 Description: Adicionar PLEXOS
 Creation Block: 15471155
 Status: Active
 Result: Undefined
 Organizations: 1,2,3,5,6,7,8,9
 Votes: Approval,NotVoted,Approval,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted
 Cancelation reason:
 ```

Com essa consulta pode-se ver e mais detalhes o que será executado caso a proposta seja aprovada. As organizações participantes são listadas no campo `Organizations`.

Uma vez que se conhece os detalhes da proposta, torna-se necessário enviar um voto. Somente é permitido **um voto por organização**. E, uma vez que o voto seja enviado, **não há como alterá-lo ou cancelá-lo**.

Para enviar o voto, deve-se usar o comando:
```
node governance.js castVote <proposalId> <approve>
```

Onde:
- `proposalId`: É o identificador da proposta criada.
- `approve`: Pode ser `true` ou `false`, caso se queira aprovar ou rejeitar a proposta, respectivamente.

Como resultado:
- A proposta será aprovada caso se atinja mais da metade de votos para aprovação.
- A proposta será rejeitada caso se atinja mais da metade de votos para reprovação ou o mesmo número de votos de aprovação.
- A proposta ficará indefinida enquanto não se atingir maioria simples de votos ou empate.
- A proposta perderá sua validade se ficar indefinida até depois de sua duração prevista (`blocksDuration`).

## Execução da proposta

Uma vez aprovada, a proposta pode ser executada por qualquer administrador global de uma das organizações participantes da proposta.

A proposta pode ser executada com o comando:
```
node governance.js executeProposal <proposalId>
```

Onde `proposalId` é o identificador da proposta criada.

Não havendo qualquer problema nas chamadas programadas na proposta, a mesma será completamente executada.

Caso algum erro ocorra, é necessário tentar entender a causa do problema. Sendo uma condição resolvível por fora da governança e que não implique na alteração de chamadas (*smart contracts*, funções ou parâmetros) da proposta, uma vez que o problema seja sanado, é possível tentar nova execução. Caso contrário, a proposta ficará aprovada porém inócua, impossível de executar. Nesse caso, recomenda-se cancelar a proposta. Somente um administrador global da organização proponente ou a própria governança podem realizar o cancelamento de uma proposta.

Para cancelar a proposta:
```
node governance.js cancelProposal <proposalId> <reason>
```

Onde:
- `proposalId`: É o identificador da proposta criada.
- `reason`: Descrição do cancelamento da proposta. Parâmetro obrigatório.

No caso extremo de não ser possível um administrador global da organização proponente realizar o cancelamento, será necessário criar uma nova proposta cujo o único passo seja cancelar a proposta falha.
