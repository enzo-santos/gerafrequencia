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

Opcionalmente, [obtenha uma chave de API](https://api.invertexto.com/) do invertexto, especificamente do serviço de
feriados. Crie um arquivo *.env* no diretório raiz do repositório e adicione o seguinte conteúdo:

```env
HOLIDAYS_API_TOKEN=<SEU TOKEN DE API AQUI>
```

Opcionalmente, ative o executável globalmente:

```shell
dart pub global activate --source path .
```

## Uso

Rode utilizando o arquivo de exemplo:

```shell
dart run bin/generate.dart assets/example/gerafrequencia.config.yaml
```

Ou, se você ativou o executável globalmente:

```shell
gtimesheet assets/example/gerafrequencia.config.yaml
```

Será gerado um
[arquivo PDF de saída](https://github.com/enzo-santos/gerafrequencia/blob/main/assets/example/Frequencia_2023-06.pdf)
contendo as informações lidas do arquivo YAML.

### Validando o arquivo de configuração

Este projeto contém um [arquivo *schema.json*](https://github.com/enzo-santos/gerafrequencia/blob/main/schema.json) para
validar seu arquivo de configuração customizado. Para utilizar no IntelliJ IDEA, por exemplo,

1. com a IDE aberta, abra o diretório do projeto
2. crie um arquivo YAML chamado *gerafrequencia.config.yaml* em qualquer lugar do projeto e abra-o
3. no canto inferior direito da tela, clique em "No JSON schema"
4. na lista suspensa que aparecerá, clique em "New Schema Mapping..."
5. no campo "Name", insira *gerafrequencia*
6. no campo "Schema file or URL", selecione o arquivo *schema.json* que está na raiz deste repositório
7. no campo "Schema version", selecione "JSON Schema version 4"
8. no símbolo de +, selecione "Add File Path Pattern" e insira *gerafrequencia.config.yaml*
9. clique em OK

Ao seguir esses passos, seu arquivo YAML poderá ser validado ao editá-lo usando a IDE.
