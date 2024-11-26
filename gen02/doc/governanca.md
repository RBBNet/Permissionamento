# Governança e Processos de Votação de Propostas

## USGOV01 - Administrador Global cria nova proposta para para que as organizações aprovem ou rejeitem alguma ação<a id="usgov01"></a>

**DÚVIDA**: Qualquer administrador global pode criar a proposta? Ou somente administradores globais de organizações com direito a voto?

Critérios de aceitação:
1. Somente Administradores Globais, vinculados a organizações ativas, podem criar propostas.
2. Administrador Global informa:
   1. Lista de endereços a serem chamados caso a proposta seja aceita.
   2. Lista de dados de chamada (*calldata*) a serem utilizados para cada um dos endereços informados.
   3. Limite de blocos para aprovação da proposta.
   4. Descrição da proposta.
3. A lista de endereços e a lista de *calldatas* devem ter o mesmo número de elementos.
4. A proposta é criada:
   1. Com identificador correspondente ao hash das informações fornecidas para sua criação: endereços, *calldatas*, limite de blocos e descrição.
   2. Com situação ativa.
   3. Com resultado indefinido.
   4. Vinculada a todas as organizações com direito de voto.
   5. São armazenados:
      1. O criador da proposta.
      2. A lista de endereços a serem chamados.
      3. A lista de *calldatas*.
      4. A descrição da proposta.
      5. O bloco de criação da proposta.
      6. Limite de blocos para aprovação da proposta.
5. A ocorrência da criação da proposta deve emitir um evento, registrando:
   1. O identificador da proposta
   2. O criador da proposta
6. O identificador da proposta é retornado como resultado.


## USGOV02 – Administrador Global cancela uma proposta para que não possa mais receber votos e nem ser executada<a id="usgov02"></a>

Critérios de aceitação:
1. Somente Administradores Globais ativos, vinculados a organizações ativas, podem cancear propostas.
2. Somente o criador de uma proposta pode realizar o cancelamento.
3. O Administrador Global informa o identificador da proposta a ser encerrada.
4. Somente propostas ativas podem ser canceladas.
5. Caso o limite de blocos estabelecido para a proposta tenha sido ultrapassado e a proposta ainda esteja indefinida, a proposta é marcada como rejeitada.
   1. A ocorrência da definição do resultado da proposta deve emitir um evento, registrando:
      1. O identificador da proposta
      2. O resultado da proposta
6. Somente propostas com resultado indefinido podem ser canceladas.
7. A proposta é marcada como cancelada.
   1. A ocorrência do cancelamento da proposta deve emitir um evento, registrando:
      1. O identificador da proposta


## USGOV03 – Administrador Global envia voto para apuração de resultado de proposta<a id="usgov03"></a>

**DÚVIDA**: Permitir que o admin de uma organização sobrescreva seu voto?

Critérios de aceitação:
1. Somente Administradores Globais ativos, vinculados a organizações ativas, podem enviar voto.
2. Administrador Global informa o identificador da proposta e o valor de seu voto (aprovação ou rejeição).
3. A proposta tem que estar ativa.
4. A organização do administrador deve constar na lista de organizações vinculadas à proposta.
5. Somente pode haver um voto por organização.
6. O voto somente pode ser marcado até o limite de blocos estabelecido para a proposta. Caso o limite de blocos tenha sido ultrapassado:
   1. O voto é descartado.
   2. A proposta é marcada como encerrada.
   3. A história é encerrada.
7. Registra-se o voto enviado para a organização do administrador.
8. A ocorrência do voto deve emitir um evento, registrando:
   1. O identificador da proposta
   2. O administrador votante
   3. O voto
9. Verifica-se se já é possível atingir maioria simples (metade mais uma das organizações da lista de proposta).
   1. Caso já exista maioria simples, registra-se o resultado da proposta, de aprovação ou rejeição.
   2. Caso todos os votos já tenham sido realizados e haja empate, registra-se o resultado da proposta como rejeição.
   3. A ocorrência da definição do resultado da proposta deve emitir um evento, registrando:
      1. O identificador da proposta
      2. O resultado da proposta


## USGOV04 – Administrador Global excuta proposta para que as ações aprovadas sejam realizadas<a id="usgov04"></a>

Critérios de aceitação:
1. ???


## USGOV05 – Observardor consulta proposta para avaliar sua situação

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o identificador da proposta.
3. São retornados os dados cadastrais da proposta.
