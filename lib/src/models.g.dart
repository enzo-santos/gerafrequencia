// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const [
      'logradouro',
      'numero',
      'bairro',
      'cep',
      'cidade',
      'uf'
    ],
    disallowNullValues: const [
      'logradouro',
      'numero',
      'bairro',
      'cep',
      'cidade',
      'uf'
    ],
  );
  return Address(
    streetName: json['logradouro'] as String,
    number: json['numero'] as int,
    district: json['bairro'] as String,
    cep: json['cep'] as String,
    city: json['cidade'] as String,
    state: json['uf'] as String,
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'logradouro': instance.streetName,
      'numero': instance.number,
      'bairro': instance.district,
      'cep': instance.cep,
      'cidade': instance.city,
      'uf': instance.state,
    };

Division _$DivisionFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['sigla', 'nome', 'orgao', 'endereco'],
    disallowNullValues: const ['sigla', 'nome', 'orgao', 'endereco'],
  );
  return Division(
    id: json['sigla'] as String,
    name: json['nome'] as String,
    companyName: json['orgao'] as String,
    address: Address.fromJson(json['endereco'] as Map),
  );
}

Map<String, dynamic> _$DivisionToJson(Division instance) => <String, dynamic>{
      'sigla': instance.id,
      'nome': instance.name,
      'orgao': instance.companyName,
      'endereco': instance.address.toJson(),
    };

Config _$ConfigFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['ano', 'mes'],
    disallowNullValues: const ['ano', 'mes'],
  );
  return Config(
    year: json['ano'] as int,
    month: json['mes'] as int,
    headerData: json['cabecalho'] == null
        ? null
        : BinaryData.fromJson(json['cabecalho'] as String),
    fill: json['enforcar'] as bool? ?? false,
    holidays:
        (json['feriados'] as List<dynamic>?)?.map((e) => e as int).toList() ??
            [],
    additionalHolidays:
        (json['facultados'] as List<dynamic>?)?.map((e) => e as int).toList() ??
            [],
  );
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'ano': instance.year,
      'mes': instance.month,
      'cabecalho': instance.headerData?.toJson(),
      'enforcar': instance.fill,
      'feriados': instance.holidays,
      'facultados': instance.additionalHolidays,
    };

Department _$DepartmentFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['nome', 'sigla', 'telefone', 'email', 'diretoria'],
    disallowNullValues: const [
      'nome',
      'sigla',
      'telefone',
      'email',
      'diretoria'
    ],
  );
  return Department(
    name: json['nome'] as String,
    id: json['sigla'] as String,
    phoneNumber: json['telefone'] as String,
    email: json['email'] as String,
    location: json['diretoria'] as String,
  );
}

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{
      'nome': instance.name,
      'sigla': instance.id,
      'telefone': instance.phoneNumber,
      'email': instance.email,
      'diretoria': instance.location,
    };

Employee _$EmployeeFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['nome', 'cargo', 'departamento'],
    disallowNullValues: const ['nome', 'cargo', 'departamento'],
  );
  return Employee(
    id: json['matricula'] as String?,
    name: json['nome'] as String,
    role: json['cargo'] as String,
    location: json['departamento'] as String,
  );
}

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'matricula': instance.id,
      'nome': instance.name,
      'cargo': instance.role,
      'departamento': instance.location,
    };

Holiday _$HolidayFromJson(Map json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'date'],
    disallowNullValues: const ['name', 'date'],
  );
  return Holiday(
    name: json['name'] as String,
    date: DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$HolidayToJson(Holiday instance) => <String, dynamic>{
      'name': instance.name,
      'date': instance.date.toIso8601String(),
    };
