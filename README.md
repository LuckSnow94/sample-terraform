# Sample-Terraform

Exemplo de aplicação de Terraform com a ferramenta Localstack.

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)

## Inicialização

Na pasta raiz do projeto, execute o script abaixo:

```sh
make install
```

## Teste

Utilize o curl para testar a aplicação:

```sh
curl -d 'foo' -H 'Content-Type: text/plain' http://localhost:4566/restapis/2hn5iav6jk/dev/_user_request_/test
```
