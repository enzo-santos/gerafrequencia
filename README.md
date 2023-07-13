# gerafrequencia

Gerador de frequências a partir de um arquivo YAML.

Seus recursos são:

- Cabeçalhos
- Feriados com base na [API de feriados do invertexto](https://api.invertexto.com/api-feriados)
- Dias facultados quando ocorrem entre um final de semana e um feriado

Baseado no modelo de frequência da Secretaria Municipal de Educação de Belém.

## Configuração

Com o Git instalado na sua máquina, clone este repositório:

```shell
git clone https://github.com/enzo-santos/gerafrequencia.git
cd gerafrequencia
```

Com o Dart instalado na sua máquina, instale as dependências do projeto:

```shell
dart pub get
```

Gere os modelos utilizados pelo programa:

```shell
dart run build_runner build
```

Opcionalmente, [obtenha uma chave de API](https://api.invertexto.com/) do invertexto, 
especificamente do serviço de feriados. Crie um arquivo *.env* no diretório raiz do repositório e 
adicione o seguinte conteúdo:

```env
HOLIDAYS_API_TOKEN=<SEU TOKEN DE API AQUI>
```

Opcionalmente, ative o executável globalmente:

```shell
dart pub global activate --source path .
```

## Uso

Rode o arquivo de exemplo:

```shell
dart run bin/generate.dart assets/example/config.yaml
```

Ou, se você ativou o executável globalmente:

```shell
gtimesheet assets/example/config.yaml
```

Será gerado um arquivo PDF de saída contendo as informações lidas do arquivo YAML.
