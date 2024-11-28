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

  Cenário: Criação de proposta
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria uma proposta com alvo o smart contract de teste com dados "0xcc95d1ce00000000000000000000000000000000000000000000000000000000000007e8", limite de 30000 blocos e descrição "Ajustando código para 2024"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta criada pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta criada tem situação "Active", resultado "Undefined" e organizações "1,2,3,5"

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

  Cenário: Tentativa de envio de voto por organização não participante

  Cenário: Tentativa de envio de voto por diferentes perfis

  Cenário: Tentativa de envio de voto com perfis de acesso sem privilégio

  Cenário: Tentativa de envio de voto com conta inativa

  Cenário: Tentativa de envio de voto com conta não cadastrada

  Cenário: Tentativa de envio de voto para proposta inexistente
  
  Cenário: Tentativa de envio de voto para proposta não ativa
  
  Cenário: Consulta de proposta não existente
    Quando um observador consulta a proposta 1 ocorre erro "ProposalNotFound"
