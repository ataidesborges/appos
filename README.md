### [Instalação](Instalacao_xampp_windows.md)

1. Faça o download dos arquivos.
2. Extraia o pacote e copie para seu webserver.
3. Rode o comando `composer install --no-dev` a partir da raiz do projeto.
4. Acesse sua URL e inicie a instalação, é bem simples, basta preencher as informações no assistente de instalação **appos**.
5. Configure o email de envio em Configurações > Sistema > E-mail .
6. Configurar cron jobs para envio de e-mail:
    ##### Enviar emails pendentes a cada 2 minutos.
    - */2 * * * * php /var/www/index.php email/process
    ##### Enviar emails com falha a cada 5 minutos.
    - */5 * * * * php /var/www/index.php email/retry

    ##### Obs: O path até o index.php (/var/www/) deve ser configurado conforme o seu ambiente


### Instalação (Docker)

1. Faça o download dos arquivos.
2. Instale o [Docker](https://docs.docker.com/install/) e o [Docker Compose](https://docs.docker.com/compose/install/).
3. Entre na pasta `docker` no seu terminal e rode o comando `docker-compose up --force-recreate`.
4. Acesse a URL `http://localhost:8000/` no navegador e inicie a instalação.
5. Na etapa de configuração use as seguintes configurações:
```
1. Por favor, insira as informações da sua conexão de banco de dados.
Host: mysql
Usuário: appos
Senha: appos
Banco de Dados: appos

2. Por favor, insira as informações para sua conta de administrador.
Configure do jeito que quiser.

3. Por favor, insira a URL.
URL: http://localhost:8000/
```
6. Configure o email de envio em Configurações > Sistema > E-mail .

    ##### Obs: Cuide da pasta `docker/data`, onde é pasta que o mysql do docker salva os arquivos. Se for deletada você perderá seu banco de dados.
    ##### Obs2: O PhpMyAdmin também e instalado e pode ser acessado em `http://localhost:8080/`.

### Instalação Automatizada
Tutorial Instalação: [https://youtu.be/NgXzzBB_2bM?si=FS_R2xq_W0Jnfn33](https://www.youtube.com/watch?v=aZE-LW_YOE4)
#### Windows 10/11
1. Execute o Prompt de Comando ou PowerShell como Administrador;
2. Execute o comando: `PowerShell -command "& { iwr https://raw.githubusercontent.com/ataidesborges/appos/master/install.bat -OutFile appos_Install.bat }; .\appos_Install.bat"`
3. Siga as instrunções na tela.

#### Linux (Ubuntu/Debian)
1. Abra o Terminal ou acesse seu servidor via SSH;
2. Eleve o privilégio aplicando `sudo su` (Recomendado);
3. Execute o comando: `curl -o appos_Install.sh -L https://raw.githubusercontent.com/ataidesborges/appos/master/install.sh && chmod +x appos_Install.sh && ./appos_Install.sh`
4. Siga as instruções na tela.

### Atualização

1. Faça o backup dos arquivos e do banco de dados:
2. Logado como administrador vá em `configurações > backup`.
3. Dentro da pasta `Assets` copie as pastas `anexos`, `arquivos`, `uploads`, `userimage` e qualquer personalização feita dentro da pasta `img`.
4. Dentro da pasta `application` copie o arquivo `.env`.;
5. Substitua os arquivos pelos da nova versão.
6. Rode o comando `composer install --no-dev` a partir da raiz do projeto.
7. Restaure os backups para seus locais devidos.
8. Logue no sistema como administrador e navegue até Configurações -> Sistema e clique no botão `Atualizar Banco de Dados` para atualizar seu banco de dados.
    Obs.: Também é possível atualizar o banco de dados via terminal rodando o comando `php index.php tools migrate` a partir da raiz do projeto;
9. Pronto, sua atualização está concluída;

### Atualização (Docker)

1. Pare o docker de rodar;
2. Faça o backup dos arquivos e do banco de dados:
3. Logado como administrador vá em `configurações > backup`.
4. Dentro da pasta `Assets` copie as pastas `anexos`, `arquivos`, `uploads`, `userimage` e qualquer personalização feita dentro da pasta `img`.
5. Dentro da pasta `application` copie o arquivo `.env`.
6. Substitua os arquivos pelos da nova versão;
7. Entre na pasta `docker` no seu terminal e rode o comando `docker-compose up --force-recreate`;
8. Logue no sistema como administrador e navegue até Configurações -> Sistema e clique no botão `Atualizar Banco de Dados` para atualizar seu banco de dados.
    Obs.: Também é possível atualizar o banco de dados via terminal rodando o comando `php index.php tools migrate` a partir da raiz do projeto;
9. Restaure os backups para seus locais devidos;
10. Pronto, sua atualização está concluída;

### Atualização via sistema

1. Primeiro é necessário atualizar manualmente o sistema para a versão v4.4.0;
2. Quando estiver nessa versão é possível atualizar o sistema clicando no botão "Atualizar appos" em Sistema >> Configurações;
3. Serão baixados e atualizados todos os arquivos exceto: `config.php`, `database.php` e `email.php`;

### Comandos de terminal

Para listar todos os comandos de terminal disponíveis, basta executar o comando `php index.php tools` a partir da raiz do projeto, após feita todo o processo de instalação.


### Frameworks/Bibliotecas
* [bcit-ci/CodeIgniter](https://github.com/bcit-ci/CodeIgniter)
* [twbs/bootstrap](https://github.com/twbs/bootstrap)
* [jquery/jquery](https://github.com/jquery/jquery)
* [jquery/jquery-ui](https://github.com/jquery/jquery-ui)
* [mpdf/mpdf](https://github.com/mpdf/mpdf)
* [Matrix Admin](http://wrappixel.com/demos/free-admin-templates/matrix-admin/index.html)
* [filp/whoops](https://github.com/filp/whoops)

### Requerimentos
* PHP = 8.2
* MySQL
* Composer
