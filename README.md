# Sample-Terraform

Exemplo de aplicação de Terraform com a ferramenta Localstack, utilizando uma função Lambda e uma API Gateway.

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/)
- [AWS-CLI](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Python](https://python.org.br/instalacao-linux/)

## Inicialização

Atualize seu sistema com o seguinte comando pelo terminal:

```sh
sudo apt update && sudo apt upgrade
```

Instale a ferramenta **make**:

```sh
$ sudo apt install make
```

Verifique a criação do diretório e a versão da ferramenta:

```sh
$ ls /usr/bin/make
/usr/bin/make
```

```sh
$ make -version
GNU Make x.x.x
[...]
```

Na pasta raiz do projeto, execute o seguinte script:

```sh
$ make install
[...]
Outputs:

rest_api_id = "<rest_api_id>"
```

## Teste

Instale a ferramenta **curl**:

```sh
$ sudo apt install curl
```

Verifique a instalação da ferramenta:

```sh
$ curl --version
curl x.x.x
[...]
```

Execute o seguinte comando para testar a aplicação, substituindo o _rest_api_id_ pelo valor do parâmetro do final da etapa de [**inicialização**](#inicialização):

```sh
curl -d 'foo' -H 'Content-Type: text/plain' http://localhost:4566/restapis/<rest_api_id>/dev/_user_request_/test
```
