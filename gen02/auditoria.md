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


### Referências

- [PIP virtual environments](https://packaging.python.org/en/latest/tutorials/installing-packages/#creating-and-using-virtual-environments)
- [Slither](https://github.com/crytic/slither)
- [Mythril](https://github.com/ConsenSys/mythril)
