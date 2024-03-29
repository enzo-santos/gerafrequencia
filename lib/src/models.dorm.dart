// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// OrmGenerator
// **************************************************************************

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class Address {
  factory Address.fromJson(Map json) => _$AddressFromJson(json);

  const Address({
    required this.streetName,
    required this.number,
    required this.district,
    required this.cep,
    required this.city,
    required this.state,
  });

  @JsonKey(
    name: 'logradouro',
    required: true,
    disallowNullValue: true,
  )
  final String streetName;

  @JsonKey(
    name: 'numero',
    required: true,
    disallowNullValue: true,
  )
  final int number;

  @JsonKey(
    name: 'bairro',
    required: true,
    disallowNullValue: true,
  )
  final String district;

  @JsonKey(
    name: 'cep',
    required: true,
    disallowNullValue: true,
  )
  final String cep;

  @JsonKey(
    name: 'cidade',
    required: true,
    disallowNullValue: true,
  )
  final String city;

  @JsonKey(
    name: 'uf',
    required: true,
    disallowNullValue: true,
  )
  final String state;

  Map<String, Object?> toJson() => _$AddressToJson(this);
}

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class Division {
  factory Division.fromJson(Map json) => _$DivisionFromJson(json);

  const Division({
    required this.id,
    required this.name,
    required this.companyName,
    required this.address,
  });

  @JsonKey(
    name: 'sigla',
    required: true,
    disallowNullValue: true,
  )
  final String id;

  @JsonKey(
    name: 'nome',
    required: true,
    disallowNullValue: true,
  )
  final String name;

  @JsonKey(
    name: 'orgao',
    required: true,
    disallowNullValue: true,
  )
  final String companyName;

  @JsonKey(
    name: 'endereco',
    required: true,
    disallowNullValue: true,
  )
  final Address address;

  Map<String, Object?> toJson() => _$DivisionToJson(this);
}

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class Config {
  factory Config.fromJson(Map json) => _$ConfigFromJson(json);

  const Config({
    required this.year,
    required this.month,
    required this.headerData,
    required this.fill,
    required this.holidays,
    required this.additionalHolidays,
  });

  @JsonKey(
    name: 'ano',
    required: true,
    disallowNullValue: true,
  )
  final int year;

  @JsonKey(
    name: 'mes',
    required: true,
    disallowNullValue: true,
  )
  final int month;

  @JsonKey(name: 'cabecalho')
  final BinaryData? headerData;

  @JsonKey(
    name: 'enforcar',
    defaultValue: false,
  )
  final bool fill;

  @JsonKey(
    name: 'feriados',
    defaultValue: [],
  )
  final List<int> holidays;

  @JsonKey(
    name: 'facultados',
    defaultValue: [],
  )
  final List<int> additionalHolidays;

  Map<String, Object?> toJson() => _$ConfigToJson(this);
}

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class Department {
  factory Department.fromJson(Map json) => _$DepartmentFromJson(json);

  const Department({
    required this.name,
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.location,
  });

  @JsonKey(
    name: 'nome',
    required: true,
    disallowNullValue: true,
  )
  final String name;

  @JsonKey(
    name: 'sigla',
    required: true,
    disallowNullValue: true,
  )
  final String id;

  @JsonKey(
    name: 'telefone',
    required: true,
    disallowNullValue: true,
  )
  final String phoneNumber;

  @JsonKey(
    name: 'email',
    required: true,
    disallowNullValue: true,
  )
  final String email;

  @JsonKey(
    name: 'diretoria',
    required: true,
    disallowNullValue: true,
  )
  final String location;

  Map<String, Object?> toJson() => _$DepartmentToJson(this);
}

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class Employee {
  factory Employee.fromJson(Map json) => _$EmployeeFromJson(json);

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.location,
  });

  @JsonKey(name: 'matricula')
  final String? id;

  @JsonKey(
    name: 'nome',
    required: true,
    disallowNullValue: true,
  )
  final String name;

  @JsonKey(
    name: 'cargo',
    required: true,
    disallowNullValue: true,
  )
  final String role;

  @JsonKey(
    name: 'departamento',
    required: true,
    disallowNullValue: true,
  )
  final String location;

  Map<String, Object?> toJson() => _$EmployeeToJson(this);
}

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
)
class Holiday {
  factory Holiday.fromJson(Map json) => _$HolidayFromJson(json);

  const Holiday({
    required this.name,
    required this.date,
  });

  @JsonKey(
    name: 'name',
    required: true,
    disallowNullValue: true,
  )
  final String name;

  @JsonKey(
    name: 'date',
    required: true,
    disallowNullValue: true,
  )
  final DateTime date;

  Map<String, Object?> toJson() => _$HolidayToJson(this);
}

class Dorm {
  const Dorm(this._engine);

  final BaseEngine _engine;
}
