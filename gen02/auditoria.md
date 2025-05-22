# Auditoria de *smart contracts*

## Preparação de ambiente

É necessário ter o Python 3.x instalado no ambiente local para execução das ferramentas de auditoria.

Criando um *virtual environment* do instalador de pacotes do Python (PIP):
```bash
python3 -m venv .
```


## Slither

Instalando o Slither:
```bash
python3 -m pip install slither-analyzer
```

Executanto a auditoria:
```bash
slither .
```


## Mythril

Instalando o Mythril:
```bash
python3 -m pip install mythril
```

Executanto a auditoria:
```bash
myth analyze <solidity-file> --solc-json mythril-solc.json
```

Exemplos:
```
# myth analyze contracts/AccountRulesV2Impl.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.

# myth analyze contracts/Governance.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.

# myth analyze contracts/NodeRulesV2Impl.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.

# myth analyze contracts/OrganizationImpl.sol --solc-json mythril-solc.json
The analysis was completed successfully. No issues were detected.
```


## Testes de mutação

Para executar testes de mutação, utilize o script:
```bash
python3 mutation_tester.py <solidity-file>
```

Exemplos:
```bash
python3 mutation_tester.py contracts/Governance.sol
python3 mutation_tester.py contracts/OrganizationImpl.sol
python3 mutation_tester.py contracts/AccountRulesV2Impl.sol
python3 mutation_tester.py contracts/NodeRulesV2Impl.sol
python3 mutation_tester.py contracts/Pagination.sol
```


## Testes de *fuzzing*

Para realização de testes de *fuzzing*, faz-se necessário a instalação da ferramenta Foundry. Ela pode ser instalada via *script* automatizado ou baixando-se [binários pré-compilados das *releases*](https://github.com/foundry-rs/foundry/releases) da ferramenta.

Para utilização de *script* automatizado, execute o comando abaixo:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Para mais informações sobre a instalação do Foundry, utilize a [documentação da ferramenta](https://book.getfoundry.sh/getting-started/installation).

Para executar um teste específico (modo verboso):
```bash
forge test <nome_do_contrato> -vvv
```

Para executar uma função específica dentro de um teste (modo verboso):
```bash
forge test <nome_do_contrato> --match-test <nome_da_funcao> -vvv
```

**Observação**: A [opção `-vvv`](https://book.getfoundry.sh/reference/cli/forge/test) é usada para exibir logs detalhados dos testes.

Para executar todos os testes:
```bash
forge test
```

Para executar testes com fuzzing (ex: 1000 execuções aleatórias):
```bash
forge test --fuzz-runs 1000
```

Exemplo prático:
```bash
forge test AccountRulesV2Impl --match-test addLocalAccount --fuzz-runs 100000 -vvv
```


### Referências

- [PIP virtual environments](https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-and-using-virtual-environments)
- [Slither](https://github.com/crytic/slither)
- [Mythril](https://github.com/ConsenSys/mythril)
- [Foundry](https://book.getfoundry.sh/)
  - [forge](https://book.getfoundry.sh/reference/cli/forge)