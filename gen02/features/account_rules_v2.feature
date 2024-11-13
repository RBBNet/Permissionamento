# language: pt

Funcionalidade: Gestão de contas

  Contexto:
    Dado que o smart contract de gestão de endereços de admin está implantado
    # A conta 0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199 é utilizada como admin,
    # conforme conceito da primeira geração do permissionamento, que representará
    # o smart contract de governança/votação.
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin
    # BNDES será organização 1
    E a organização "BNDES" com direito de voto "true"
    # TCU será organização 2
    E a organização "TCU" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    # Administrador global da organização 1 - BNDES
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso

  ##############################################################################
  # Adição de contas locais
  ##############################################################################
  
  Cenário: Adição de conta local, com administrador global e com administrador local
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador local do BNDES adiciona nova conta de usuário
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e admin "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"

  Cenário: Tentativa de adição de conta local com conta não permissionada
    # Uma conta qualquer tenta adicionar uma nova conta local
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com conta sem perfil de acesso necessário
    # Administrador global do BNDES adiciona nova conta de usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e admin "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Nova conta de usuário tenta adicionar nova conta de usuário
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com endereço inválido
    # Administrador global do BNDES tenta adicionar nova conta local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x0000000000000000000000000000000000000000" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local repetida
    # Administrador global do BNDES adiciona novo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global do BNDES tenta adicionar novamente o mesmo administrador local
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "DuplicateAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com administrador de organização inativa
    # Governança adiciona organização 3 - Dataprev
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "Dataprev" e direito de voto "true"
    Então a organização 3 é "Dataprev" e direito de voto "true"
    E verifico se a organização 3 está ativa o resultado é "true"
    # Governança adiciona novo administrador global para a Dataprev
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 3 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 3, papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "true"
    # Administrador global da Dataprev adiciona nova conta de usuário
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 3 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    # Governança exclui a Dataprev, logo, suas contas ficarão inativas
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    Então verifico se a organização 3 está ativa o resultado é "false"
    E verifico se a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" está ativa o resultado é "false"
    # Administrador global da Dataprev tenta adiciona nova conta de usuário, mas está inativo
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    Então ocorrre erro "InactiveAccount" na tentativa de adição de conta

  #Cenário: Tentativa de adição de conta local com administrador local inativo
    # TODO Implementar
    
  Cenário: Tentativa de adição de conta local com perfil de administrador global
    # Administrador global do BNDES tenta adicionar outro administrador global como "conta local"
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com perfil inválido
    # Administrador global do BNDES tenta adicionar conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "UNKNOWN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta local com hash zerado
    # Administrador global do BNDES tenta adicionar conta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorrre erro "InvalidHash" na tentativa de adição de conta


  ##############################################################################
  # Adição de contas via governança
  ##############################################################################

  Cenário: Adição de conta de administrador global pela governança
    # Governança adiciona administrador novo global para o BNDES
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    # Governança adiciona conta de usuário para o BNDES
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    Então a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8", organização 1, papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e admin "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"

  Cenário: Tentativa de adição de conta por conta não autorizada ("por fora" da governança)
    # Administrador global do BNDES tenta cadastrar diretamente outro administrador global
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "UnauthorizedAccess" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com endereço inválido
    # Governança tenta adicionar conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x0000000000000000000000000000000000000000" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta repetida
    # Governança adiciona conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E o evento "AccountAdded" foi emitido para a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec", organização 1, papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e admin "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199"
    # Governança tenta adicionar novamente a mesma conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "DuplicateAccount" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com perfil inválido
    # Governança tenta adicionar conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "UNKNOWN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então ocorrre erro "InvalidRole" na tentativa de adição de conta

  Cenário: Tentativa de adição de conta com hash zerado
    # Governança tenta adicionar conta
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" na organização 1 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    Então ocorrre erro "InvalidHash" na tentativa de adição de conta
