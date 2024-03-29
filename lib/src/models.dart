import 'dart:convert';
import 'dart:typed_data';

import 'package:dorm_annotations/dorm_annotations.dart';
import 'package:dorm_framework/dorm_framework.dart';

part 'models.dorm.dart';

part 'models.g.dart';

class Base64Data {
  final Uint8List bytes;

  factory Base64Data.fromJson(String data) {
    return Base64Data(base64.decode(data));
  }

  const Base64Data(this.bytes);

  String toJson() => base64.encode(bytes);
}

@Data()
abstract class _Address {
  @Field(name: 'logradouro')
  String get streetName;

  @Field(name: 'numero')
  int get number;

  @Field(name: 'bairro')
  String get district;

  @Field(name: 'cep')
  String get cep;

  @Field(name: 'cidade')
  String get city;

  @Field(name: 'uf')
  String get state;
}

@Data()
abstract class _Division {
  /// Sigla desta diretoria.
  ///
  /// Deve ser único dentro do órgão.
  @Field(name: 'sigla')
  String get id;

  /// Nome desta diretoria.
  @Field(name: 'nome')
  String get name;

  /// Nome do órgão o qual esta diretoria faz parte.
  @Field(name: 'orgao')
  String get companyName;

  @ModelField(name: 'endereco', referTo: _Address)
  get address;
}

@Data()
abstract class _Config {
  /// Ano vigente da frequência a ser gerada.
  @Field(name: 'ano')
  int get year;

  /// Mês vigente da frequência a ser gerada.
  @Field(name: 'mes')
  int get month;

  /// Conteúdo da imagem a ser usada como cabeçalho.
  @Field(name: 'cabecalho')
  Base64Data? get headerBytes;

  /// Se o único dia entre um domingo e um feriado deve ser considerado
  /// como facultado.
  @Field(name: 'enforcar', defaultValue: false)
  bool get fill;

  /// Os dias considerados feriados no mês [month] do ano [year].
  @Field(name: 'feriados', defaultValue: [])
  List<int> get holidays;

  /// Os dias considerados facultados no mês [month] do ano [year].
  @Field(name: 'facultados', defaultValue: [])
  List<int> get additionalHolidays;
}

@Data()
abstract class _Department {
  @Field(name: 'nome')
  String get name;

  @Field(name: 'sigla')
  String get id;

  @Field(name: 'telefone')
  String get phoneNumber;

  @Field(name: 'email')
  String get email;

  @Field(name: 'diretoria')
  String get location;
}

@Data()
abstract class _Employee {
  @Field(name: 'matricula')
  String? get id;

  @Field(name: 'nome')
  String get name;

  @Field(name: 'cargo')
  String get role;

  @Field(name: 'departamento')
  String get location;
}

@Data()
abstract class _Holiday {
  @Field(name: 'name')
  String get name;

  @Field(name: 'date')
  DateTime get date;
}
