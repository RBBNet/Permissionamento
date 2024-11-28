# language: pt

Funcionalidade: Governança do permissionamento

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
    # Dataprev será a organização 3
    E a organização "DATAPREV" com direito de voto "true"
    # PUC-Rio será a organização 4
    E a organização "PUC-Rio" com direito de voto "false"
    # CPQD será a organização 5
    E a organização "CPQD" com direito de voto "true"
    # OrgExc será organização 6
    E a organização "OrgExc" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    # Administrador global da organização 1 - BNDES
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    # Administrador global da organização 3 - Dataprev
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    # Administrador global da organização 4 - PUC-Rio
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097"
    # Administrador global da organização 5 - CPQD
    E a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    # Administrador global da organização 6 - OrgExc
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Governança adiciona conta de administração local para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" na organização 1 com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    # Governança adiciona conta de implantação para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" na organização 1 com papel "DEPLOYER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    # Governança adiciona conta de usuário para o BNDES
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" na organização 1 com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    # Verificando cadastro das organizações
    E a lista de organizações é "1,BNDES,true|2,TCU,true|3,DATAPREV,true|4,PUC-Rio,false|5,CPQD,true|6,OrgExc,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" é da organização 1 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    E a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" é da organização 1 com papel "DEPLOYER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000003" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" é da organização 4 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" é da organização 5 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" é da organização 6 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    # Governança exclui OrgExc
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 6
    E verifico se a organização 6 está ativa o resultado é "false"
    E verifico se a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" está ativa o resultado é "false"
    E a lista de organizações é "1,BNDES,true|2,TCU,true|3,DATAPREV,true|4,PUC-Rio,false|5,CPQD,true"
    E implanto o smart contract de governança do permissionamento
    E a implantação do smart contract de governança do permissionamento ocorre com sucesso
    E implanto um smart contract mock para que sofra ações da governança
    E a implantação do smart contract mock ocorre com sucesso


  ##############################################################################
  # Criação de proposta
  ##############################################################################

  Cenário: Criação de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    E a proposta tem situação "Active", resultado "Undefined" e votos "NotVoted,NotVoted,NotVoted,NotVoted"

  Cenário: Tentativa de criar proposta com perfis de acesso sem privilégio
    # Administrador Local do BNDES tenta criar uma proposta
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    
    # Implantador de smart contracts do BNDES tenta criar uma proposta
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    
    # Usuário do BNDES tenta criar uma proposta
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    

  Cenário: Tentativa de criar proposta com conta inativa
    # Administrador Global da OrgExc tenta criar uma proposta
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    

  Cenário: Tentativa de criar proposta com conta não cadastrada
    # Conta não cadastrada tenta criar uma proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "UnauthorizedAccess" na criação da proposta    

  Cenário: Tentativa de criar proposta com as listas de targets e calldatas de tamanhos diferentes
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8,0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "InvalidArgument" na criação da proposta    

  Cenário: Tentativa de criar proposta com duração de zero blocos
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 0 blocos e descrição "Ajustando código para 2024"
    Então ocorre erro "InvalidArgument" na criação da proposta    


  ##############################################################################
  # Cancelamento de proposta
  ##############################################################################

  Cenário: Cancelamento de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta
    E a proposta criada tem situação "Canceled", resultado "Undefined" e organizações "1,2,3,5"
    E a proposta tem situação "Canceled", resultado "Undefined" e votos "NotVoted,NotVoted,NotVoted,NotVoted"

  Cenário: Tentativa de cancelamento de proposta com resultado já definido
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Global do BNDES tenta cancelar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta
    Então ocorre erro "IllegalState" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta com conta inativa
    # Governança adiciona a OrgExc2 como organização 7
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "OrgExc" e direito de voto "true"
    Então a organização 7 é "OrgExc" e direito de voto "true"
    E verifico se a organização 7 está ativa o resultado é "true"
    # Governança adiciona novo administrador global para a OrgExc2
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" na organização 7 com papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000001"
    Então a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 7 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000001" e situação ativa "true"
    # Novo administrador global cadastra nova proposta
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5,7"
    # Governança exclui a organização 7 - OrgExc2
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 7
    # Então a OrgExc2 e suas contas ficam inativas
    E verifico se a organização 7 está ativa o resultado é "false"
    E verifico se a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" está ativa o resultado é "false"
    # Novo administrador global tenta cancelar a proposta
    Quando a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" cancela a proposta
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta com conta não cadastrada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Conta não cadastrada tenta cancelar proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" cancela a proposta
    Então ocorre erro "UnauthorizedAccess" no cancelamento da proposta

  Cenário: Tentativa de cancelamento de proposta inexistente
    # Administrador Global do BNDES tenta cancelar uma proposta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta 1
    Então ocorre erro "ProposalNotFound" no cancelamento da proposta
  
  Cenário: Tentativa de cancelamento de proposta já cancelada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta
    Então a proposta é cancelada com sucesso
    E o evento "ProposalCanceled" é emitido para a proposta
    # Administrador Global do BNDES tenta cancelar a proposta novamente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta
    Então ocorre erro "IllegalState" no cancelamento da proposta

  Cenário: Tentativa de envio de voto para proposta encerrada
    # Administrador Global do BNDES cria uma proposta com apenas 1 bloco de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Já foi "gasto 1 bloco", então a duração da proposta já esgotou
    # Administrador Global do TCU tenta enviar voto para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o evento "ProposalFinished" é emitido para a proposta
    # Administrador Global do BNDES tenta cancelar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta
    Então ocorre erro "IllegalState" no cancelamento da proposta


  ##############################################################################
  # Envio de votos
  ##############################################################################

  Cenário: Aprovação de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,Approval"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a proposta tem situação "Active", resultado "Approved" e votos "Approval,Approval,NotVoted,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Administrador Global da Dataprev vota para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    E a proposta tem situação "Active", resultado "Approved" e votos "Approval,Approval,Rejection,Approval"

  Cenário: Rejeição de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Rejection,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Rejection,NotVoted,NotVoted,Approval"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Rejection,Rejection,NotVoted,Approval"
    # Administrador Global da Dataprev vota para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    E a proposta tem situação "Active", resultado "Rejected" e votos "Rejection,Rejection,Rejection,Approval"
    # Proposta é rejeitada por maioria
    E o evento "ProposalRejected" é emitido para a proposta

  Cenário: Empate e consequente rejeição de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,Approval,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,Approval,NotVoted,Rejection"
    # Administrador Global da Dataprev vota para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec"
    E a proposta tem situação "Active", resultado "Rejected" e votos "Approval,Approval,Rejection,Rejection"
    # Proposta não chega a ter aprovação da maioria, então é rejeitada
    E o evento "ProposalRejected" é emitido para a proposta

  Cenário: Encerramento de proposta por tempo de duração
    # Administrador Global do BNDES cria uma proposta com apenas 1 bloco de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Já foi "gasto 1 bloco", então a duração da proposta já esgotou
    # Administrador Global do TCU tenta enviar voto para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,NotVoted"

  Cenário: Encerramento de proposta aprovada
    # Administrador Global do BNDES cria uma proposta com apenas 3 blocos de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Approval,NotVoted,NotVoted,Approval"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Approval" pela conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a proposta tem situação "Active", resultado "Approved" e votos "Approval,Approval,NotVoted,Approval"
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    # Já foram "gastos 3 blocos", então a duração da proposta já esgotou
    # Administrador Global da Dataprev tenta enviar voto para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Approved" e votos "Approval,Approval,NotVoted,Approval"

  Cenário: Encerramento de proposta rejeitada
    # Administrador Global do BNDES cria uma proposta com apenas 3 blocos de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 3 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    # Administrador Global do BNDES vota para rejeitar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Rejection,NotVoted,NotVoted,NotVoted"
    # Administrador Global do CPQD vota para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71"
    E a proposta tem situação "Active", resultado "Undefined" e votos "Rejection,NotVoted,NotVoted,Rejection"
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Rejection"
    Então o voto é registrado com sucesso
    E o evento "OrganizationVoted" é emitido para a proposta com voto de "Rejection" pela conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a proposta tem situação "Active", resultado "Rejected" e votos "Rejection,Rejection,NotVoted,Rejection"
    # Proposta é rejeitada por maioria
    E o evento "ProposalRejected" é emitido para a proposta
    # Já foram "gastos 3 blocos", então a duração da proposta já esgotou
    # Administrador Global da Dataprev tenta enviar voto para rejeitar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Rejection"
    Então o evento "ProposalFinished" é emitido para a proposta
    E a proposta tem situação "Finished", resultado "Rejected" e votos "Rejection,Rejection,NotVoted,Rejection"

  Cenário: Tentativa de envio de voto por organização não participante
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global da PUC-Rio (sem direito a voto) tenta enviar voto
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto com perfis de acesso sem privilégio
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Local do BNDES tenta enviar voto
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto
    # Implantador de smart contracts do BNDES tenta enviar voto
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto
    # Usuário contracts do BNDES tenta enviar voto
    Quando a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto com conta inativa
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global da OrgExc tenta enviar voto
    Quando a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto com conta não cadastrada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Conta não cadastrada tenta enviar voto
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então ocorre erro "UnauthorizedAccess" no envio do voto

  Cenário: Tentativa de envio de voto para proposta inexistente
    # Administrador Global do BNDES tenta enviar voto para uma proposta inexistente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval" para a proposta 1
    Então ocorre erro "ProposalNotFound" no envio do voto
  
  Cenário: Tentativa de envio de voto para proposta encerrada
    # Administrador Global do BNDES cria uma proposta com apenas 1 bloco de duração
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 1 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Já foi "gasto 1 bloco", então a duração da proposta já esgotou
    # Administrador Global do TCU tenta enviar voto para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o evento "ProposalFinished" é emitido para a proposta
    # Administrador Global do CPQD tenta enviar voto para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então ocorre erro "IllegalState" no envio do voto

  Cenário: Tentativa de envio de voto para proposta cancelada
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    # Administrador Global do BNDES cancela a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cancela a proposta
    Então a proposta é cancelada com sucesso
    # Administrador Global do CPQD tenta enviar voto para aprovar a proposta
    Quando a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" envia um voto de "Approval"
    Então ocorre erro "IllegalState" no envio do voto

  
  ##############################################################################
  # Consulta de proposta e votos
  ##############################################################################

  Cenário: Consulta de proposta e votos
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"
    E a proposta tem situação "Active", resultado "Undefined" e votos "NotVoted,NotVoted,NotVoted,NotVoted"
    
  Cenário: Consulta de proposta não existente
    Quando um observador consulta a proposta 1 ocorre erro "ProposalNotFound"
