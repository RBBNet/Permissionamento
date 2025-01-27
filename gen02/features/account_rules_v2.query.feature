# language: pt

Funcionalidade: Consultas de contas

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
    # OrgExc será organização 3
    E a organização "OrgExc" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    # Administrador global da organização 1 - BNDES
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    # Administrador global da organização 2 - TCU
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    # Administrador global da organização 3 - OrgExc
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30"
    E implanto o smart contract de gestão de contas
    E a implantação do smart contract de gestão de contas ocorre com sucesso
    # Administrador global do BNDES adiciona novas contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000005"
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000006"
    # Administrador global da OrgExc adiciona novas contas
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" adiciona a conta local "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" adiciona a conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" com papel "USER_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    # Verificando cadastro das organizações
    E a lista de organizações é "1,BNDES,true|2,TCU,true|3,OrgExc,true"
    # Verificando cadastro das contas
    E a quantidade total de contas é 7
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" é da organização 1 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000005" e situação ativa "true"
    E a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8" é da organização 1 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000006" e situação ativa "true"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" é da organização 2 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" é da organização 3 com papel "GLOBAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000000" e situação ativa "true"
    E a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" é da organização 3 com papel "LOCAL_ADMIN_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000004" e situação ativa "true"
    E a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" é da organização 3 com papel "USER_ROLE", data hash "0x0000000000000000000000000000000000000000000000000000000000000002" e situação ativa "true"
    # Governança exclui a OrgExc, logo, suas contas ficarão inativas
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"
    E a lista de organizações é "1,BNDES,true|2,TCU,true"
    E verifico se a conta "0x2546BcD3c84621e976D8185a91A922aE77ECEc30" está ativa o resultado é "false"
    E verifico se a conta "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" está ativa o resultado é "false"

  ##############################################################################
  # Consulta de contas
  ##############################################################################

  Cenário: Consulta de todas as contas em uma única página
    Quando consulto as contas a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|2,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|3,0x2546BcD3c84621e976D8185a91A922aE77ECEc30,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true|1,0x70997970C51812dc3A010C7d01b50e0d17dc79C8,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000006,true|3,0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,LOCAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000004,true|3,0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000002,true"
    E a quantidade total de contas é 7
    Quando consulto as contas a partir da página 1 com tamanho de página 7
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|2,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|3,0x2546BcD3c84621e976D8185a91A922aE77ECEc30,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true|1,0x70997970C51812dc3A010C7d01b50e0d17dc79C8,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000006,true|3,0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,LOCAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000004,true|3,0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000002,true"
    E a quantidade total de contas é 7

  Cenário: Consulta de todas as contas com página de um elemento apenas
    Quando consulto as contas a partir da página 1 com tamanho de página 1
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true"
    Quando consulto as contas a partir da página 2 com tamanho de página 1
    Então o resultado da consulta de contas é "2,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true"
    Quando consulto as contas a partir da página 3 com tamanho de página 1
    Então o resultado da consulta de contas é "3,0x2546BcD3c84621e976D8185a91A922aE77ECEc30,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true"
    Quando consulto as contas a partir da página 4 com tamanho de página 1
    Então o resultado da consulta de contas é "1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true"
    Quando consulto as contas a partir da página 5 com tamanho de página 1
    Então o resultado da consulta de contas é "1,0x70997970C51812dc3A010C7d01b50e0d17dc79C8,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000006,true"
    Quando consulto as contas a partir da página 6 com tamanho de página 1
    Então o resultado da consulta de contas é "3,0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,LOCAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000004,true"
    Quando consulto as contas a partir da página 7 com tamanho de página 1
    Então o resultado da consulta de contas é "3,0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000002,true"

  Cenário: Consulta de todas as contas com páginação em sequência
    Quando consulto as contas a partir da página 1 com tamanho de página 2
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|2,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true"
    Quando consulto as contas a partir da página 2 com tamanho de página 2
    Então o resultado da consulta de contas é "3,0x2546BcD3c84621e976D8185a91A922aE77ECEc30,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true"
    Quando consulto as contas a partir da página 3 com tamanho de página 2
    Então o resultado da consulta de contas é "1,0x70997970C51812dc3A010C7d01b50e0d17dc79C8,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000006,true|3,0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,LOCAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000004,true"
    Quando consulto as contas a partir da página 4 com tamanho de página 2
    Então o resultado da consulta de contas é "3,0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000002,true"

  Cenário: Consulta de todas as contas após exclusão de contas
    # Administrador global do BNDES exclui conta de usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a exclusão é realizada com sucesso
    E a quantidade total de contas é 6
    Quando consulto as contas a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|2,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|3,0x2546BcD3c84621e976D8185a91A922aE77ECEc30,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true|3,0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000002,true|3,0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,LOCAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000004,true"
  
  Cenário: Consulta de todas as contas com parâmetro de página inválido
    Quando consulto as contas a partir da página 0 com tamanho de página 10
    Então ocorre erro "InvalidArgument" na consulta de conta
    
  Cenário: Consulta de todas as contas com parâmetro de tamanho de página inválido
    Quando consulto as contas a partir da página 1 com tamanho de página 0
    Então ocorre erro "InvalidArgument" na consulta de conta
    
  Cenário: Consulta de todas as contas com paginação além do tamanho do resultado
    Quando consulto as contas a partir da página 10 com tamanho de página 1000
    Então ocorre erro "InvalidArgument" na consulta de conta


  ##############################################################################
  # Consulta de contas por organização
  ##############################################################################

  Cenário: Consulta de contas por organização em uma única página
    Quando consulto as contas da organização 1 a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true|1,0x70997970C51812dc3A010C7d01b50e0d17dc79C8,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000006,true"
    E a quantidade de contas da organização 1 é 3
    Quando consulto as contas da organização 2 a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é "2,0xFABB0ac9d68B0B445fB7357272Ff202C5651694a,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true"
    E a quantidade de contas da organização 2 é 1
    Quando consulto as contas da organização 3 a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é "3,0x2546BcD3c84621e976D8185a91A922aE77ECEc30,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|3,0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097,LOCAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000004,true|3,0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000002,true"
    E a quantidade de contas da organização 3 é 3

  Cenário: Consulta de contas por organização com página de um elemento apenas
    Quando consulto as contas da organização 1 a partir da página 1 com tamanho de página 1
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true"
    Quando consulto as contas da organização 1 a partir da página 2 com tamanho de página 1
    Então o resultado da consulta de contas é "1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true"
    Quando consulto as contas da organização 1 a partir da página 3 com tamanho de página 1
    Então o resultado da consulta de contas é "1,0x70997970C51812dc3A010C7d01b50e0d17dc79C8,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000006,true"

  Cenário: Consulta de contas por organização após exclusão de contas
    # Administrador global do BNDES exclui conta de usuário
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" exclui a conta local "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então a exclusão é realizada com sucesso
    Quando consulto as contas da organização 1 a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é "1,0x71bE63f3384f5fb98995898A86B02Fb2426c5788,GLOBAL_ADMIN_ROLE,0x0000000000000000000000000000000000000000000000000000000000000000,true|1,0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,USER_ROLE,0x0000000000000000000000000000000000000000000000000000000000000005,true"
    E a quantidade de contas da organização 1 é 2

  Cenário: Consulta de contas de organização que não existe
    Quando consulto as contas da organização 10 a partir da página 1 com tamanho de página 100
    Então o resultado da consulta de contas é ""
    E a quantidade de contas da organização 10 é 0

  Cenário: Consulta de contas por organização com parâmetro de página inválido
    Quando consulto as contas da organização 1 a partir da página 0 com tamanho de página 10
    Então ocorre erro "InvalidArgument" na consulta de conta
    
  Cenário: Consulta de contas por organização com parâmetro de tamanho de página inválido
    Quando consulto as contas da organização 1 a partir da página 1 com tamanho de página 0
    Então ocorre erro "InvalidArgument" na consulta de conta
    
  Cenário: Consulta de contas por organização com paginação além do tamanho do resultado
    Quando consulto as contas da organização 1 a partir da página 10 com tamanho de página 1000
    Então ocorre erro "InvalidArgument" na consulta de conta


