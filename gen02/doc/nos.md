# Nós

## USN01 - Administrador cadastra novo nó de sua organização para que receba permissão para se conectar à RBB
Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem realizar o cadastro.
2. O administrador informa o endereço do nó, seu nome e seu tipo.
3. O nó não pode já estar cadastrado.
4. O nó é criado e vinculado à organização do administrador solicitante.
5. A ocorrência do cadastro deve emitir um evento, registrando:
    1. O endereço do nó;
    2. O administrador.

## USN02 - Administrador exclui nó de sua organização para que não possa mais se conectar à RBB
Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem excluir nós.
2. O administrador informa o endereço do nó a ser excluído.
3. O administrador somente pode excluir nós vinculados à sua organização.
4. O nó é excluído.
5. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço do nó;
   2. O administrador.
  
## USN03 - Administrador altera cadastro de nó de sua organização para corrigir informações incorretas
Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem alterar o cadastro de nós.
2. O administrador informa o endereço, nome e tipo do nó a ser alterado.
3. O administrador somente pode alterar nós vinculados à sua organização.
4. O novo nome e tipo são alterados no cadastro do nó.
5. A ocorrência da alteração deve emitir um evento, registrando:
   1.	O endereço do nó;
   2. O administrador.
  
## USN04 - Governança cadastra novo nó para que receba permissão para se conectar à RBB
Critérios de aceitação:
1. Somente o processo de governança pode realizar o cadastro.
2. São informados o identificador da organização responsável pelo nó, seu endereço, seu nome e seu tipo.
3. A organização responsável e o tipo informado devem ser válidos.
4. O nó não pode já estar cadastrado.
5. O nó é criado, associado à organização indicada e com o nome e tipo indicados.
6. A ocorrência do cadastro deve emitir um evento, registrando:
   1. O endereço do nó;
   2. O identificador da votação correspondente no processo de governança.
  
## USN05 - Governança exclui nó para que não possa mais se conectar à RBB
Critérios de aceitação:
1. Somente o processo de governança pode realizar a exclusão.
2. É informado o endereço do nó a ser excluído.
3. O nó informado deve ser válido.
4. O nó é excluído.
5. A ocorrência da exclusão deve emitir um evento, registrando:
   1. O endereço do nó;
   2. O identificador da votação correspondente no processo de governança.
  
## USN06 - Administrador altera situação do nó (desativar/reativar)
Critérios de aceitação:
1. Somente Administradores Globais ou Administradores Locais ativos, vinculados a organizações ativas, podem desativar ou reativar um nó.
2. O administrador somente pode desativar ou reativar nós vinculados à sua organização.
3. É informado o endereço do nó e a situação desejada (desativar/reativar).
4. As informações fornecidas devem ser válidas.
5. A situação do nó é alterada.
6. A ocorrência da alteração deve emitir um evento, registrando:
   1. O endereço da conta que desativou/reativou o nó;
   2. A nova situação do nó.

## USN07 - Observador verifica se nó está ativo para saber se pode se conectar à RBB
Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa o endereço do nó a ser verificado.
3. Caso a organização a qual o nó está vinculado esteja ativa e o nó esteja ativo , retorna-se que o nó se encontra ativo.
   1. Em qualquer outra situação, indica-se que o nó se encontra inativo.
   2. Caso o endereço não corresponda a um nó existente, também se indica resposta de nó inativo.
  
## USN08 - Observador consulta nó para obter seus dados cadastrais
Critérios de aceitação:
1. Qualquer pessoa pode realizar a consulta.
2. Observador informa endereço do nó a ser consultado.
3. São retornados o endereço, o nome, o tipo, a organização responsável e a situação do nó correspondente.

## USN09 - Besu verifica permissão de um nó para decidir se uma conexão pode ser realizada 
Critérios de aceitação:
1. Besu informa endereço do nó que quer se conectar à rede.
2. Somente nós cadastrados, ativos e vinculados a organizações ativas podem realizar conexões.
