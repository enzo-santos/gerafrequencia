import 'dart:convert';
import 'dart:typed_data';

import 'package:dartx/dartx.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'models.dart';

Future<Uint8List> createTimesheetFromJson(Map<String, Object?> jsonData) async {
  final DotEnv env = DotEnv()..load();
  final String? holidaysApiToken = env['HOLIDAYS_API_TOKEN'];

  return createTimesheet(
    config: Config.fromJson(jsonData['config'] as Map),
    allDivisions: (jsonData['diretorias'] as List)
        .map((data) => Division.fromJson(data as Map))
        .toList(),
    allDepartments: (jsonData['departamentos'] as List)
        .map((data) => Department.fromJson(data as Map))
        .toList(),
    allEmployees: (jsonData['servidores'] as List)
        .map((data) => Employee.fromJson(data as Map))
        .toList(),
    holidaysApiToken: holidaysApiToken,
  );
}

Future<Uint8List> createTimesheet({
  required Config config,
  required List<Division> allDivisions,
  required List<Department> allDepartments,
  required List<Employee> allEmployees,
  String? holidaysApiToken,
}) async {
  await initializeDateFormatting('pt_BR');

  final now = DateTime(config.year, config.month);

  final Uint8List? headerBytes = config.headerBytes?.bytes;

  final Map<String, Division> divisions = allDivisions.fold({}, (acc, current) {
    final id = '${current.id}/${current.companyName}';
    final previous = acc[id];
    if (previous != null) {
      throw StateError(
        'diretorias ${previous.name} e ${current.name} '
        'têm a mesma sigla dentro do mesmo órgão: $id',
      );
    }
    acc[id] = current;
    return acc;
  });
  if (divisions.isEmpty) {
    throw StateError('pelo menos uma diretoria deve ser informada');
  }

  final Map<String, Department> departments =
      allDepartments.fold({}, (acc, current) {
    final id = '${current.id}/${current.location}';
    final previous = acc[id];
    if (previous != null) {
      throw StateError(
        'departamentos ${previous.name} e ${current.name} '
        'têm a mesma sigla dentro da mesma diretoria: $id',
      );
    }
    acc[id] = current;
    return acc;
  });

  allEmployees.fold({}, (acc, current) {
    final localId = current.id;
    if (localId != null) {
      final globalId = '$localId/${current.location}';
      final previous = acc[globalId];
      if (previous != null) {
        throw StateError(
          'servidores ${previous.name} e ${current.name} '
          'têm a mesma matrícula dentro do mesmo departamento: $localId',
        );
      }
      acc[globalId] = current;
    }
    return acc;
  });
  final List<Employee> employees = allEmployees;

  final Set<DateTime> holidays = {};
  final Set<DateTime> additionalHolidays = config.additionalHolidays
      .map((day) => DateTime(config.year, config.month, day))
      .toSet();
  if (holidaysApiToken != null) {
    final Uri apiUrl = Uri(
      scheme: 'https',
      host: 'api.invertexto.com',
      pathSegments: ['v1', 'holidays', '${now.year}'],
      queryParameters: {'token': holidaysApiToken, 'estado': 'PA'},
    );
    final http.Response response = await http.get(apiUrl);
    holidays.addAll((json.decode(response.body) as List)
        .cast<Map>()
        .map(Holiday.fromJson)
        .map((holiday) => holiday.date)
        .where(now.isAtSameMonthAs)
        .toSet());
  }
  holidays.addAll(
      config.holidays.map((day) => DateTime(config.year, config.month, day)));

  final pw.Document pdf = pw.Document();
  for (Employee employee in employees) {
    final department = departments[employee.location];
    if (department == null) {
      throw StateError(
        'servidor ${employee.name} faz parte de um departamento '
        'não declarado em `departamentos`: ${employee.location}',
      );
    }

    final division = divisions[department.location];
    if (division == null) {
      throw StateError(
        'departamento ${department.name} faz parte de uma diretoria '
        'não declarada em `diretorias`: ${department.location}',
      );
    }

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) {
        return pw.Column(
          children: [
            if (headerBytes != null)
              pw.ClipRect(
                child: pw.Image(
                  pw.MemoryImage(headerBytes.buffer.asUint8List()),
                  fit: pw.BoxFit.contain,
                  alignment: pw.Alignment.topCenter,
                ),
              ),
            pw.SizedBox(height: 20),
            pw.Column(
              children: [
                pw.Text(division.name.toUpperCase()),
                pw.SizedBox(height: 5),
                pw.Text(department.id.toUpperCase()),
                pw.SizedBox(height: 5),
                pw.Text('LISTA DE FREQUÊNCIA'),
                pw.SizedBox(height: 5),
                pw.Text(intl.DateFormat('MMMM/yyyy', 'pt_BR')
                    .format(now)
                    .toUpperCase())
              ],
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 50,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.RichText(
                    text: pw.TextSpan(
                      children: [
                        const pw.TextSpan(text: 'Nome do servidor: '),
                        pw.TextSpan(
                          text: employee.name.toUpperCase(),
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            const pw.TextSpan(text: 'Cargo: '),
                            pw.TextSpan(
                              text: '${employee.role}/'
                                      '${department.id}/'
                                      '${division.id}/'
                                      '${division.companyName}'
                                  .toUpperCase(),
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      if (employee.id != null)
                        pw.RichText(
                          text: pw.TextSpan(
                            children: [
                              const pw.TextSpan(text: 'Matrícula: '),
                              pw.TextSpan(
                                text: employee.id,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 20),
              child: pw.Table(
                border: pw.TableBorder.all(),
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: List.generate(now.daysInMonth, (i) {
                  final int day = i + 1;
                  final DateTime date = now.copyWith(day: day);
                  final String? text;
                  if (date.weekday == DateTime.saturday) {
                    text = 'Sábado';
                  } else if (date.weekday == DateTime.sunday) {
                    text = 'Domingo';
                  } else if (holidays.contains(date.date)) {
                    text = 'FERIADO';
                  } else if (additionalHolidays.contains(date.date)) {
                    text = 'FACULTADO';
                  } else if (config.fill) {
                    const Duration oneDay = Duration(days: 1);
                    final DateTime yesterday = date.subtract(oneDay);
                    final DateTime tomorrow = date.add(oneDay);
                    final bool isOptional = (yesterday.isWeekend &&
                            holidays.contains(tomorrow.date)) ||
                        (holidays.contains(yesterday.date) &&
                            tomorrow.isWeekend);
                    if (isOptional) {
                      text = 'FACULTADO';
                    } else {
                      text = null;
                    }
                  } else {
                    text = null;
                  }
                  return pw.TableRow(
                    children: [
                      pw.Center(
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 1),
                          child: pw.Text('$day'),
                        ),
                      ),
                      for (int i = 0; i < 4; i++)
                        pw.Center(child: pw.Text(text ?? ' ')),
                    ],
                  );
                })
                    .prependElement(pw.TableRow(children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Center(
                          child: pw.Text(
                            'Dia',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Center(
                          child: pw.Text(
                            'Hora da entrada',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 4,
                        child: pw.Center(
                          child: pw.Text(
                            'Assinatura',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 3,
                        child: pw.Center(
                          child: pw.Text(
                            'Hora da saída',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 4,
                        child: pw.Center(
                          child: pw.Text(
                            'Assinatura',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                        ),
                      ),
                    ]))
                    .toList(),
              ),
            ),
            pw.Expanded(child: pw.SizedBox.shrink()),
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 20),
              child: pw.Center(
                child: pw.Column(
                  children: [
                    pw.Divider(color: PdfColors.grey800),
                    pw.Text(
                      [
                        '${division.address.streetName}, '
                            'nº ${division.address.number}',
                        division.address.district,
                        'CEP: ${division.address.cep}',
                        '${division.address.city}/${division.address.state}',
                      ].join(' - '),
                      style: const pw.TextStyle(color: PdfColors.grey800),
                    ),
                    pw.Text(
                      [
                        'E-mail: ${department.email}',
                        'Fone: ${department.phoneNumber}',
                      ].join(' - '),
                      style: const pw.TextStyle(color: PdfColors.grey800),
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 20),
          ],
        );
      },
    ));
  }

  return await pdf.save();
}
