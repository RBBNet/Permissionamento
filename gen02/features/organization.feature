# language: pt

Funcionalidade: Gestão de organizações

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin
    E a organização "BNDES"
    E a organização "TCU"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    
  Cenário: Consulta de dados cadastrais de organização
    E a organização 1 é "BNDES" e direito de voto "true"
    E a organização 2 é "TCU" e direito de voto "true"

  Cenário: Verificação de organizações ativas e inativas
    Quando verifico se a organização 1 está ativa o resultado é "true"
    Quando verifico se a organização 2 está ativa o resultado é "true"
    Quando verifico se a organização 3 está ativa o resultado é "false"

  Cenário: Adição de organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "Dataprev" e direito de voto "true"
    Então a organização 3 é "Dataprev" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    E o evento "OrganizationAdded" foi emitido para a organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "PUC-Rio" e direito de voto "false"
    Então a organização 4 é "PUC-Rio" e direito de voto "false"
    E o evento "OrganizationAdded" foi emitido para a organização 4
    E verifico se a organização 4 está ativa o resultado é "true"
  
  Cenário: Tentativa de adição de organização por conta não autorizada ("por fora" da governança)
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" adiciona a organização "Dataprev" e direito de voto "true"
    Então ocorre erro "UnauthorizedAccess" na tentativa de adição de organização

  Cenário: Atualização de organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" altera a organização 1 com nome "Banco Nacional de Desenvolvimento Econômico e Social" e direito de voto "false"
    Então a organização 1 é "Banco Nacional de Desenvolvimento Econômico e Social" e direito de voto "false"
    E o evento "OrganizationUpdated" foi emitido para a organização 1

  Cenário: Tentativa de atualização de organização por conta não autorizada ("por fora" da governança)
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" altera a organização 1 com nome "Banco Nacional de Desenvolvimento Econômico e Social" e direito de voto "false"
    Então ocorre erro "UnauthorizedAccess" na tentativa de atualização de organização

  Cenário: Tentativa de atualização de organização inexistente
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" altera a organização 3 com nome "Dataprev" e direito de voto "false"
    Então ocorre erro "OrganizationNotFound" na tentativa de atualização de organização

  Cenário: Exclusão de organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "Dataprev" e direito de voto "true"
    Então a organização 3 é "Dataprev" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    E o evento "OrganizationAdded" foi emitido para a organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    Então o evento "OrganizationDeleted" foi emitido para a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"

  Cenário: Tentativa de exclusão de organização com apenas 2 organizações cadastradas
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 2
    Então ocorre erro "IllegalState" na tentativa de exclusão de organização

  Cenário: Tentativa de exclusão de organização por conta não autorizada ("por fora" da governança)
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" exclui a organização 3
    Então ocorre erro "UnauthorizedAccess" na tentativa de exclusão de organização

  Cenário: Tentativa de exclusão de organização inexistente
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    Então ocorre erro "OrganizationNotFound" na tentativa de exclusão de organização
