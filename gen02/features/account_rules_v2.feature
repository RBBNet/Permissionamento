# language: pt

Funcionalidade: Gestão de contas

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin
    E a organização "BNDES"
    E a organização "TCU"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso

  ##############################################################################
  # Adição de contas locais
  ##############################################################################
  
  Cenário: Adição de conta local, com administrador global e com administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e admin "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"

  Cenário: Tentativa de adição de conta local com conta não permissionada
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com conta sem perfil de acesso necessário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e admin "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com endereço inválido
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x0000000000000000000000000000000000000000" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local repetida
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "DuplicateAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com administrador de organização inativa
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "Dataprev" e direito de voto "true"
    Então a organização 3 é "Dataprev" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 3 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 3, papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "true"
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 3 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    Então verifico se a organização 3 está ativa o resultado é "false"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "false"
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    Então ocorrre erro "InactiveAccount" na tentativa de adição de conta

  #Cenário: Tentativa de adição de conta local com administrador local inativo
    # TODO Implementar
    
  Cenário: Tentativa de adição de conta local com perfil de administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com perfil inválido
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "INVALID_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com hash zerado
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorrre erro "InvalidHash" na tentativa de adição de conta


  ##############################################################################
  # Adição de contas via governança
  ##############################################################################

  Cenário: Adição de conta de administrador global pela governança
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e admin "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"

  Cenário: Tentativa de adição de conta por conta não autorizada ("por fora" da governança)
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com endereço inválido
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x0000000000000000000000000000000000000000" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta repetida
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "DuplicateAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com perfil inválido
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "INVALID_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com hash zerado
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorrre erro "InvalidHash" na tentativa de adição de conta
