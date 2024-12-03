# Contas

## USACC01 - Administrador cadastra nova conta de sua organização para que possa enviar transações à rede ou executar funcionalidades de permissionamento no âmbito de sua própria organização<a id="usacc01"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar o cadastro.
2. O administrador informa o endereço, papel desejado e um hash dos dados cadastrais da conta mantidos *off chain* pela organização.
3. A conta não pode já estar cadastrada.
4. O papel informado deve ser válido e não pode ser de Administrador Global.
5. O hash dos dados cadastrais da conta não pode estar vazio/zerado.
6. A conta é criada e vinculada à organização do administrador solicitante.
7. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O papel
   4. O hash dos dados cadastrais
   5. O administrador que realizou a ação


## USACC02 - Administrador exclui conta de sua organização para que não possa mais enviar transações à rede ou executar funcionalidades de permissionamento no âmbito de sua própria organização<a id="usacc02"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem excluir contas.
2. O administrador informa o endereço da conta a ser excluída.
3. O administrador somente pode excluir contas vinculadas à sua organização.
4. O papel da conta a ser excluída não pode ser de Administrador Global.
5. A conta é excluída.
6. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O administrador que realizou a ação


## USACC03 – Administrador altera papel de uma conta de sua organização para elevar ou rebaixar privilégios de acesso<a id="usacc03"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a alteração.
2. O administrador informa o endereço da conta e o novo papel a ser atribuído.
3. O administrador somente pode alterar contas vinculadas à sua organização.
4. O papel informado deve ser válido.
5. A alteração não pode envolver o papel de Administrador Global, seja no estado original ou no estado final da alteração.
6. O novo papel é atribuído à conta.
7. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O novo papel informado para a conta
   4. O administrador que realizou a ação


## USACC04 – Administrador altera hash de dados cadastrais de uma conta de sua organização para manter a informação de auditoria atualizada<a id="usacc04"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a alteração.
2. O administrador informa o endereço da conta e o novo hash a ser atribuído.
3. O administrador somente pode alterar contas vinculadas à sua organização.
4. O papel da conta a ser alterada não pode ser de Administrador Global.
5. O hash dos dados cadastrais da conta não pode estar vazio/zerado.
6. O hash é atribuído à conta.
7. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O novo hash informado para a conta
   4. O administrador que realizou a ação


## USACC05 – Administrador altera situação de conta da sua organização para que perca temporariamente ou para que readquira privilégios de acesso<a id="usacc05"></a>

Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar a alteração.
2. O administrador informa o endereço da conta a ser alterada e a situação desejada (ativa ou inativa).
3. O administrador somente pode alterar contas vinculadas à sua organização.
4. A alteração não pode ser para uma conta com papel de Administrador Global.
5. A situação da conta é alterada.
6. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. A nova situação informada para a conta
   4. O administrador que realizou a ação


## USACC06 - Governança cadastra nova conta para que possa ser usada no envio de transações à RBB ou executar funcionalidades de permissionamento<a id="usacc06"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar o cadastro.
2. São informados o identificador da organização responsável pela conta, o endereço, o papel desejado e um hash dos dados cadastrais da conta mantidos *off chain* pela organização.
3. A organização responsável e o papel desejado devem ser válidos.
4. A conta não pode já estar cadastrada.
5. A conta é criada e vinculada à organização informada.
6. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   3. O papel
   4. O hash dos dados cadastrais
   5. O endereço da Governança


## USACC07 - Governança exclui conta para que não tenha mais acesso à RBB<a id="usacc07"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar a exclusão.
2. É informado o endereço da conta a ser excluída.
3. A conta informada deve ser válida.
4. A exclusão só pode ocorrer se ao menos uma conta com papel Administrador Global permanecer ativa para a organização da conta a ser excluída.
5. A conta é excluída.
6. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço da conta
   2. O identificador da organização
   5. O endereço da Governança


## USACC08 - Governança configura o acesso a *smart contract* para que sua execução possa ser desativada, restrita a um conjunto determinado de endereços ou liberada para qualquer endereço<a id="usacc08"></a>

Critérios de aceitação:
1. Somente o processo de governança pode realizar a configuração.
2. São informados:
   1. O endereço do *smart contract* a ter seu acesso configurado.
   2. Se o acesso deve ser restringido ou não.
   3. No caso de haver restrição, a lista de endereços com permissão de acesso.
      1. A lista de endereços é opcional.
      2. Caso seja indicada restrição de acesso e a lista não seja informada, o *smart contract* ficará completamente inacessível (desativado).
3. Caso seja indicada limitação de acesso, o endereço do *smart contract* é adicionado à lista de restrição de acesso, juntamente com os endereços permitidos (se houver), para restringir a execução do *smart contract*.
4. Caso **não** seja indicada limitação de acesso, o endereço do *smart contract* é removido da lista de restrição de acesso, liberando completamente, para qualquer chamador, a execução do *smart contract*.
5. A ocorrência da desativação deve emitir um evento, registrando:
   1. O endereço do *smart contract*
   2. Se foi configurada restrição de acesso
   3. Lista de endereços com acesso permitido
   4. O endereço da Governança


## USACC09 - Observador verifica se conta está ativa para saber se a mesma pode ter acesso à RBB<a id="usacc09"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o endereço da conta a ser verificada.
3. Caso a organização a qual a conta está vinculada esteja ativa e a conta esteja ativa, retorna-se que a conta se encontra ativa.
   1. Em qualquer outra situação, indica-se que a conta se encontra inativa.
   2. Caso o endereço não corresponda a uma conta existente, também se indica resposta de conta inativa.


## USACC10 - Observador consulta conta para obter seus dados cadastrais<a id="usacc10"></a>

Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa endereço da conta a ser consultada.
3. São retornados o endereço, a organização responsável, o papel, o hash de dados cadastrais e a situação da conta correspondente.


## USACC11 - Besu verifica permissão de uma conta para decidir se uma transação pode ser realizada<a id="usacc11"></a>

Critérios de aceitação:
1. Besu informa endereço de origem e endereço de destino da transação.
2. Somente contas ativas e vinculadas a organizações ativas são consideradas endereços de origem válidos.
3. Caso o endereço de destino conste na lista de restrição de acesso de *smart contracts*, então o endereço de origem deve constar como endereço permitido. Caso contrário o acesso é negado.
4. Transações de implantação de *smart contract* (endereço destino igual a `0x0`) somente podem ser enviadas por contas com papel Administrador Global, Administador Local ou Implantador de Aplicações.
