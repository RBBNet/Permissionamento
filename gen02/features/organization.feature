# language: pt

Funcionalidade: Gestão de organizações

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin
    E a organização "BNDES"
    E a organização "TCU"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    E a organização 1 é "BNDES" e direito de voto "true"
    E a organização 2 é "TCU" e direito de voto "true"

  Cenário: Adição de organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "Dataprev" e direito de voto "true"
    Então a organização 3 é "Dataprev" e direito de voto "true"
    E o evento "OrganizationAdded" foi emitido para a organização 3
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "PUC-Rio" e direito de voto "false"
    Então a organização 4 é "PUC-Rio" e direito de voto "false"
    E o evento "OrganizationAdded" foi emitido para a organização 4
  
  Cenário: Tentativa de adição de organização por conta não autorizada ("por fora" da governança)
    Quando a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" adiciona a organização "Dataprev" e direito de voto "true"
    Então ocorre erro "UnauthorizedAccess" na tentativa de adição de organização
