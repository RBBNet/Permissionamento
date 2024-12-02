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
