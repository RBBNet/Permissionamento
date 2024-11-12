# language: pt

Funcionalidade: Gestão de organizações

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin
    E a organização "BNDES"
    E a organização "TCU"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    E a organização 1 é "BNDES" com direito de voto
    E a organização 2 é "TCU" com direito de voto

  Cenário: Adição de organização
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "Dataprev" com direito de voto
    Então a organização 3 é "Dataprev" com direito de voto
    E o evento "OrganizationAdded" foi emitido para a organização 3
  
