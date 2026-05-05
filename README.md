# 🐳 Lab Docker — PHP + MySQL com Apache

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-8.2-777BB4?style=for-the-badge&logo=php&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Apache](https://img.shields.io/badge/Apache-2.4-D22128?style=for-the-badge&logo=apache&logoColor=white)
![Windows](https://img.shields.io/badge/Windows_11-0078D6?style=for-the-badge&logo=windows&logoColor=white)

> Laboratório prático demonstrando a containerização de uma aplicação **PHP + MySQL** com **Apache**, utilizando **Docker Desktop** no Windows 11 com WSL.

---

## 📋 Índice

- [Sobre o Projeto](#-sobre-o-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Estrutura de Diretórios](#-estrutura-de-diretórios)
- [Configuração do Ambiente](#-configuração-do-ambiente)
  - [1. Criação do Volume MySQL](#1-criação-do-volume-mysql)
  - [2. Execução do Container MySQL](#2-execução-do-container-mysql)
  - [3. Build da Imagem PHP](#3-build-da-imagem-php)
  - [4. Execução do Container PHP](#4-execução-do-container-php)
- [Acesso à Aplicação](#-acesso-à-aplicação)
- [Encerramento](#-encerramento)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Autor](#-autor)

---

## 📌 Sobre o Projeto

Este laboratório tem como objetivo demonstrar na prática os conceitos de:

- **Containerização** de aplicações com Docker
- **Comunicação entre containers** via `--link`
- **Persistência de dados** com Docker Volumes
- **Deploy de aplicação PHP** com servidor Apache
- **Integração PHP + MySQL** dentro de containers isolados

A aplicação exibe uma lista de mensagens armazenadas no banco de dados MySQL, servida por um container PHP/Apache.

---

## ✅ Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

| Ferramenta | Versão Recomendada | Link |
|---|---|---|
| Windows 11 | — | — |
| WSL 2 | — | [Instalação WSL](https://learn.microsoft.com/pt-br/windows/wsl/install) |
| Docker Desktop | Latest | [Download Docker](https://www.docker.com/products/docker-desktop/) |

---

## 📁 Estrutura de Diretórios

```
C:\lab-php-mysql
│
├── Dockerfile
├── index.php
├── README.md
└── prints
    ├── container-executando.png
    ├── container-rodando.jpeg
    ├── container-navegando.jpeg
    └── docker-volume-mysql.png
```

---

## ⚙️ Configuração do Ambiente

### 1. Criação do Volume MySQL

Crie um volume Docker para persistência dos dados do banco:

```powershell
docker volume create mysql_data
```

Verifique se o volume foi criado:

```powershell
docker volume ls
```

> **Resultado esperado:**
>
> ![Docker Volume](prints/docker-volume-mysql.png)

---

### 2. Execução do Container MySQL

Suba o container MySQL com as credenciais e o volume criado:

```powershell
docker run -d `
  --name lab-mysql `
  -e MYSQL_ROOT_PASSWORD=labroot `
  -e MYSQL_DATABASE=labdb `
  -e MYSQL_USER=labuser `
  -e MYSQL_PASSWORD=labpass `
  -p 3306:3306 `
  -v mysql_data:/var/lib/mysql `
  mysql:8
```

Verifique se o container está em execução:

```powershell
docker ps
```

**Validação via MySQL CLI (opcional):**

```powershell
docker exec -it lab-mysql bash
mysql -u root -plabroot
SHOW DATABASES;
```

---

### 3. Build da Imagem PHP

Acesse o diretório do projeto e construa a imagem Docker:

```powershell
cd C:\lab-php-mysql
docker build -t lab-php-image .
```

Liste as imagens disponíveis para confirmar o build:

```powershell
docker images
```

**Dockerfile utilizado:**

```dockerfile
FROM php:8.2-apache
RUN docker-php-ext-install mysqli
WORKDIR /var/www/html
COPY . /var/www/html
EXPOSE 80
CMD ["apache2-foreground"]
```

---

### 4. Execução do Container PHP

Execute o container PHP linkado ao container MySQL:

```powershell
docker run -d `
  --name lab-php `
  --link lab-mysql:mysql `
  -e DB_HOST=lab-mysql `
  -e DB_USER=labuser `
  -e DB_PASSWORD=labpass `
  -e DB_NAME=labdb `
  -p 8080:80 `
  lab-php-image
```

> **Container em execução:**
>
> ![Container executando](prints/container-executando.png)

Confirme os containers ativos:

```powershell
docker ps
```

> ![Docker PS](prints/container-rodando.jpeg)

---

## 🌐 Acesso à Aplicação

Com os containers em execução, acesse a aplicação no navegador:

```
http://127.0.0.1:8080
```

> **Página exibida no navegador:**
>
> ![Aplicação rodando](prints/container-navegando.jpeg)

A página lista as mensagens inseridas automaticamente no banco de dados MySQL pelo script PHP.

---

## 🛑 Encerramento

Para parar os containers:

```powershell
docker stop lab-php
docker stop lab-mysql
```

Para remover os containers (opcional):

```powershell
docker rm lab-php
docker rm lab-mysql
```

Para remover o volume (opcional — **apaga os dados**):

```powershell
docker volume rm mysql_data
```

---

## 🛠️ Tecnologias Utilizadas

- **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** — plataforma de containerização
- **[PHP 8.2](https://www.php.net/)** com extensão `mysqli`
- **[Apache HTTP Server](https://httpd.apache.org/)** — servidor web embutido na imagem `php:8.2-apache`
- **[MySQL 8](https://dev.mysql.com/)** — banco de dados relacional
- **[WSL 2](https://learn.microsoft.com/pt-br/windows/wsl/)** — subsistema Linux no Windows

---

## 👤 Autor

**Nickolas Corazza Alves**

---

## 📝 Conclusão

Este laboratório demonstrou na prática:

- Como criar e gerenciar **volumes Docker** para persistência de dados
- Como realizar **comunicação entre containers** com `--link`
- Como **containerizar uma aplicação PHP** com servidor Apache
- Como integrar **PHP e MySQL** em um ambiente Docker isolado
- Como utilizar **variáveis de ambiente** para configuração segura de credenciais

---

> ⚠️ **Nota:** O uso de `--link` é uma abordagem legada. Em projetos mais robustos, recomenda-se utilizar **Docker Compose** com redes definidas (`networks`) para comunicação entre containers.
