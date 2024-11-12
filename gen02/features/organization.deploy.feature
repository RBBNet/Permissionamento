# language: pt

Funcionalidade: Gestão de organizações

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin

  Cenário: Implantação de smart contract
    Dado a organização "BNDES"
    E a organização "TCU"
    Quando implanto o smart contract de gestão de organizações
    Então a implantação do smart contract de gestão de organizações ocorre com sucesso
    E a organização 1 é "BNDES" e direito de voto "true"
    E a organização 2 é "TCU" e direito de voto "true"

  Cenário: Implantação de smart contract com apenas uma organização
    Dado a organização "BNDES"
    Quando implanto o smart contract de gestão de organizações
    Então ocorre erro na implantação do smart contract de gestão de organizações

  Cenário: Implantação de smart contract sem organizações
    Dado que não há organizações definidas
    Quando implanto o smart contract de gestão de organizações
    Então ocorre erro na implantação do smart contract de gestão de organizações
