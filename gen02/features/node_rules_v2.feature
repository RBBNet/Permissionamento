# language: pt

Funcionalidade: Gestão de nós
  Contexto:
#    1. implantar contrato de admin (mock)
#    2. adicionar 4 organizações à array de orgs
#    3. implantar contrato de organizações
#    4. adicionar 4 administradores globais
#    5. adicionar o contrato de gestão de contas
#    6. adicionar administradores locais
#    7. implantar contrato de nós

    Dado que o smart contract de gestão de endereços de admin está implantado
    E o endereço "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" é admin
    E a organização "BNDES" com direito de voto "true"
    E a organização "TCU" com direito de voto "true"
    E a organização "EXEMPLO" com direito de voto "true"
    E a organização "EXEMPLO2" com direito de voto "true"
    E implanto o smart contract de gestão de organizações
    E a implantação do smart contract de gestão de organizações ocorre com sucesso
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a"
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906"
    E implanto o smart contract de gestão de contas
    E a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" adiciona a conta local "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000004"
    E a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" adiciona a conta local "0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000002"
    E a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" adiciona a conta local "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000003"
    E a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" adiciona a conta local "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" com papel "LOCAL_ADMIN_ROLE" e data hash "0x0000000000000000000000000000000000000000000000000000000000000005"
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 3
    E verifico se a organização 3 está ativa o resultado é "false"
    Dado que o contrato de nós está implantado

  Cenário: Cadastro realizado por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então o evento "NodeAdded" é emitido para a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"
    E o nó de enodeHigh "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" e enodeLow "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" tem a mesma organização que o administrador "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"

  Cenário: Cadastro realizado por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então o evento "NodeAdded" é emitido para a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097"
    E o nó de enodeHigh "0x852345fa7a92fc5f4923f0ed480d0106288cf17f7712ed80edfb121e3b6a9af0" e enodeLow "0x8bdfde3661ea90ee3d94f7b6a0e8934f3d8e3eaecb2a8b8de3b6b4be66ef305c" tem a mesma organização que o administrador "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097"

  Cenário: Tentativa de cadastro por um Administrador Global inativo
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" informa o endereço "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então o erro recebido é "InactiveAccount"
    Então o nó de enodeHigh "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" e enodeLow "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33" recebe o erro "NodeNotFound"

  Cenário: Tentativa de cadastro por um Administrador Local inativo
    Quando a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" informa o endereço "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então o erro recebido é "InactiveAccount"
    Então o nó de enodeHigh "0xed75e39936d130a4698193dbc87d95520f57efb94f14343e5c948df0aab08a1b" e enodeLow "0xa50bea35df61679258485e24896d112e47ea0758b91bbbee2468ef37e82a4a33" recebe o erro "NodeNotFound"

  Cenário: Tentativa de cadastro de um nó já existente
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então o erro recebido é "DuplicateNode"

  Cenário: Tentativa de cadastro por uma conta que não é administradora
    Quando a conta "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Então o erro recebido é "UnauthorizedAccess"
    Então o nó de enodeHigh "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" e enodeLow "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" recebe o erro "NodeNotFound"

  Cenário: Exclusão de nó realizada por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então o evento "NodeDeleted" é emitido para a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788"

  Cenário: Exclusão de nó realizada por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0x71bE63f3384f5fb98995898A86B02Fb2426c5788" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então o evento "NodeDeleted" é emitido para a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097"

  Cenário: Tentativa de exclusão por um Administrador Global inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então o erro recebido é "InactiveAccount"

  Cenário: Tentativa de exclusão por um Administrador Local inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    E a conta "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199" exclui a organização 4
    Quando a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então o erro recebido é "InactiveAccount"

  Cenário: Tentativa de exclusão de nó vinculado a outra organização
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então o erro recebido é "NotLocalNode"
    # verifica se o nó ainda existe
    E o nó de enodeHigh "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" e enodeLow "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" tem a mesma organização que o administrador "0x90F79bf6EB2c4f870365E785982E1f101E93b906"

  Cenário: Exclusão de nó que não existe
    Quando a conta "0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" para exclusão
    Então o erro recebido é "NodeNotFound"

  Cenário: Alteração de cadastro realizada por um Administrador Global ativo e vinculado a uma organização ativa
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    #pegar infos antigas, armazená-las e compará-las com as novas
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o evento "NodeUpdated" é emitido para a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906"

  Cenário: Alteração de cadastro realizada por um Administrador Local ativo e vinculado a uma organização ativa
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o evento "NodeUpdated" é emitido para a conta "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65"

  Cenário: Tentativa de alteração por um Administrador Global inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0xdD2FD4581271e230360230F9337D5c0430Bf44C0" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o erro recebido é "InactiveAccount"

  Cenário: Tentativa de alteração por um Administrador Local inativo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0xbDA5747bFD65F08deb54cb465eB87D40e51B197E" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o erro recebido é "InactiveAccount"

  Cenário: Mudança para nome inválido
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "" e o tipo "Boot" para alterá-lo
    Então o nome do nó "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646" continua o mesmo

  Cenário: Tentativa de alteração de nó vinculado a outra organização
    Quando a conta "0x90F79bf6EB2c4f870365E785982E1f101E93b906" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "validator01" e o tipo "Validator" do nó para cadastrá-lo
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o erro recebido é "NotLocalNode"

  Cenário: Alteração de nó que não existe
    Quando a conta "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a" informa o endereço "0xf752f5cfcbd9be4ee1abfd8e53633ac522e180ad5214efd45d96f9de7a2476e7" "0x35d6256dbd86220376457c5a4ac8dc68b413d0b0785a73b98879a58010c65646", o nome "boot01" e o tipo "Boot" para alterá-lo
    Então o erro recebido é "NodeNotFound"