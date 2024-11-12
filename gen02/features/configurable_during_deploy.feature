# language: pt

Funcionalidade: Configuração de smart contracts durante implantação

  Cenário: Implantação, configuração e uso de smart contract bem sucedidos
    Dado que inicio a implantação do smart contract configurável
    Quando tento realizar a configuração com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    Então a configuração é feita com sucesso
    Quando tento finalizar a implantação com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    Então a implantação é finalizada com sucesso
    Quando tento executar suas funcionalidades
    Então as funcionalidades são executadas com sucesso

  Cenário: Configuração com conta diferente do owner
    Dado que inicio a implantação do smart contract configurável
    Quando tento realizar a configuração com a conta "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
    Então ocorre erro "NotOwnerAccount" na configuração

  Cenário: Configuração após término da implantação
    Dado que inicio a implantação do smart contract configurável
    E tento realizar a configuração com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    E a configuração é feita com sucesso
    E tento finalizar a implantação com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    Então a implantação é finalizada com sucesso
    Quando tento executar suas funcionalidades
    Então as funcionalidades são executadas com sucesso
    Quando tento realizar a configuração com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    Então ocorre erro "AlreadyConfigured" na configuração

  Cenário: Uso de funcionalidades antes do final da implantação
    Dado que inicio a implantação do smart contract configurável
    Quando tento executar suas funcionalidades
    Então ocorre erro "NotConfigured" na execução das funcionalidades

  Cenário: Finalização de implantação repetida
    Dado que inicio a implantação do smart contract configurável
    E tento realizar a configuração com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    E a configuração é feita com sucesso
    Quando tento finalizar a implantação com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    Então a implantação é finalizada com sucesso
    Quando tento finalizar a implantação com a conta "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
    Então ocorre erro "AlreadyConfigured" na finalização da implantação
