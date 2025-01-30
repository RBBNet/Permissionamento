# Slither

É uma ferramenta desenvolvida pela Trail of Bits para análise estática de código Solidity. Entre seus recursos constam: rapidez, é detalhada, com detecção de problemas como funções inseguras, detecta problemas de gás e vulnerabilidades comuns.

Repositório: https://github.com/crytic/slither

Vulnerabilidades que ele detecta: https://github.com/crytic/slither#detectors

Instalação

1. Criação de pasta no lugar que for mais conveniente

```solidity
mkdir auditoria_slither

cd auditoria_slither

npm init
```

2. Instalar e configurar o homebrew, no terminal digite:

```solidity
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> /home/<SEU_USER>/.bashrc

echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/<SEU_USER>/.bashrc

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

3. Instalação do python

Os sistemas GNU/Linux mais recentes já possuem uma versão do Python instalada junto com o sistema operacional. Podemos checar com o seguinte comando.

Para outros sistemas operacionais: [python.org/downloads](https://python.org/downloads)

4. Instalar e configurar solc-select:

4.1 Instalando

```bash
brew install slither-analyzer
```

4.2 Adicionar no package.json

```json
{
	"scripts":{
		"slither": "slither . --solc-remaps "
		}
}
```

5. Instalar e configurar solc-select:

```bash
brew install solc-select
solc-select install 0.5.9
solc-select use 0.5.9
```

6. Navegue até a pasta do projeto, no terminal, e digite uma das duas linhas abaixo:

```bash
slither .                                       
```

```bash
slither <nome_arquivo>.sol      
```
                
Caso haja um remapeamento: 
```bash
slither <nome_arquivo>.sol --solc-remaps @openzeppelin=../node_modules/@openzeppelin
```