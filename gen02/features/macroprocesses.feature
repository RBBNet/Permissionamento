# language: pt

Funcionalidade: Macroprocessos de gestão da RBB

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
    # RNP será organização 6
    E a organização "RNP" com direito de voto "true"
    # Prodemge será organização 7
    E a organização "Prodemge" com direito de voto "true"
    # SERPRO será organização 8
    E a organização "SERPRO" com direito de voto "true"
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
    # Administrador global da organização 6 - RNP
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30"
    # Administrador global da organização 7 - Prodemge
    E a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E"
    # Administrador global da organização 8 - SERPRO
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Verificando cadastro das organizações
    E a lista de organizações é "1,BNDES,true|2,TCU,true|3,DATAPREV,true|4,PUC-Rio,false|5,CPQD,true|6,RNP,true|7,Prodemge,true|8,SERPRO,true"
    # Verificando cadastro das contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" é da organização 4 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xcd3B766CCDd6AE721141F452C550Ca635964ce71" é da organização 5 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" é da organização 6 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" é da organização 7 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" é da organização 8 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    # Implantação do smart contract de governança
    E implanto o smart contract de governança do permissionamento
    E a implantação do smart contract de governança do permissionamento ocorre com sucesso
    E o smart contract de governança é adicionado como admin master
    

  Cenário: Entrada de uma nova organização
    # Preparação de passos para uma proposta
    Dado o alvo "OrganizationImpl" para chamada da função "addOrganization(string,bool)" com parâmetros "IBICT,true"
    E o alvo "AccountRulesV2Impl" para chamada da função "addAccount(address,uint256,bytes32,bytes32)" com parâmetros "0xBcd4042DE499D14e55001CcbB24a551F3b954096,9,0xd6e7d8560c69c7c18c2b8f3b45430215d788f128f0c04bc4a3607fe05eb5399f,0x0000000000000000000000000000000000000000000000000000000000000000"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria proposta com descrição "Inclusão do IBICT"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8" e votos "Approval,Approval,Approval,NotVoted,NotVoted,NotVoted,Approval"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E o evento "OrganizationAdded" foi emitido para a organização 9 com nome "IBICT" e direito de voto "true"
    E o evento "AccountAdded" foi emitido para a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096", organização 9, papel "GLOBAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000000"
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8" e votos "Approval,Approval,Approval,NotVoted,NotVoted,NotVoted,Approval"
    # Verificando o resultado da execução, se organização e admin global foram criados
    Então a organização 9 é "IBICT" e direito de voto "true"
    E a conta "0xBcd4042DE499D14e55001CcbB24a551F3b954096" é da organização 9 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"

  Cenário: Saída de uma organização
    # Preparando cenário - Adcionando uma nova organização via governança
    Quando a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" adiciona a organização "OrgExc" e direito de voto "true"
    Então a organização 9 é "OrgExc" e direito de voto "true"
    E verifico se a organização 9 está ativa o resultado é "true"

    # Preparação de passos para uma proposta
    Dado o alvo "OrganizationImpl" para chamada da função "deleteOrganization(uint256)" com parâmetros "9"
    # Administrador Global do BNDES cria uma proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" cria proposta com descrição "Exclusão da OrgExc"
    Então a proposta é criada com sucesso
    E o evento "ProposalCreated" é emitido para a proposta pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a proposta tem situação "Active", resultado "Undefined", organizações "1,2,3,5,6,7,8,9" e votos "NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted,NotVoted"
    # Administrador Global do BNDES vota para aprovar a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do TCU vota para aprovar a proposta
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do Dataprev vota para aprovar a proposta
    Quando a conta "0x1CBd3b2770909D4e10f157cABC84C7264073C9Ec" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global do SERPRO vota para aprovar a proposta
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Administrador Global da Prodemge vota para aprovar a proposta
    Quando a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" envia um voto de "Approval"
    Então o voto é registrado com sucesso
    # Proposta é aprovada por maioria
    E o evento "ProposalApproved" é emitido para a proposta
    E a proposta tem situação "Active", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,NotVoted,NotVoted,Approval,Approval,NotVoted"
    # Administrador Global do BNDES executa a proposta
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" executa a proposta
    Então a proposta é executada com sucesso
    E o evento "ProposalFinished" é emitido para a proposta
    E o evento "ProposalExecuted" é emitido para a proposta pela conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E o evento "OrganizationDeleted" foi emitido para a organização 9
    E a proposta tem situação "Executed", resultado "Approved", organizações "1,2,3,5,6,7,8,9" e votos "Approval,Approval,Approval,NotVoted,NotVoted,Approval,Approval,NotVoted"
    # Verificando o resultado da execução, se organização foi excluída
    E verifico se a organização 9 está ativa o resultado é "false"
