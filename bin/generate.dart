import 'dart:io';

import 'package:args/args.dart';
import 'package:gerafrequencia/gerafrequencia.dart';
import 'package:gerafrequencia/src/main.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

void main(List<String> args) async {
  final ArgParser parser = ArgParser()
    ..addOption(
      'output',
      abbr: 'o',
      help: 'arquivo de saída do comando',
    );
  final results = parser.parse(args);

  final configFile = File(results.rest.firstOrNull ??
      p.join('assets', 'gerafrequencia.config.yaml'));

  final data = loadYaml(await configFile.readAsString()) as YamlMap;
  final config = Config.fromJson(data['config']);

  final pdfBytes = await createTimesheetFromJson(Map.from(data));

  final suffix =
      intl.DateFormat('yyyy-MM').format(DateTime(config.year, config.month));
  final outputFilePath = (results['output'] as String?) ??
      p.join(configFile.parent.path, 'Frequencia_$suffix.pdf');
  await File(outputFilePath).writeAsBytes(pdfBytes);
}
