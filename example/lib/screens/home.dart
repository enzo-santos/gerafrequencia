import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;
import 'package:file_saver/file_saver.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:gerafrequencia/main.dart';
import 'package:gerafrequencia/models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../main.dart';

class _State extends ChangeNotifier {
  List<Division> get divisions {
    return const [
      Division(
        id: 'DADM',
        name: 'Diretoria de Administração',
        companyName: 'SEAD',
        address: Address(
          streetName: 'Av. Juscelino Kubitschek',
          number: 2041,
          cep: '04543-011',
          district: 'Vila Nova Conceição',
          city: 'São Paulo',
          state: 'SP',
        ),
      ),
      Division(
        id: 'DPCD',
        name: 'Diretoria de Patrimônio Cultural e Diversidade',
        companyName: 'SECULT',
        address: Address(
          cep: '14403-471',
          streetName: 'Rua Arnulfo de Lima',
          number: 2385,
          district: 'Vila Santa Cruz',
          city: 'Franca',
          state: 'SP',
        ),
      ),
      Division(
        id: 'DTEC',
        name: 'Diretoria de Tecnologia',
        companyName: 'SETI',
        address: Address(
          cep: '05420-918',
          streetName: 'Avenida Rebouças',
          number: 3970,
          district: 'Pinheiros',
          city: 'São Paulo',
          state: 'SP',
        ),
      ),
    ];
  }

  List<Department> get departments {
    return const [
      Department(
        name: 'Coordenação de Compras e Contratos',
        id: 'CCO',
        phoneNumber: '(91) 3258-7921',
        email: 'cco@sead.gov.br',
        location: 'DADM/SEAD',
      ),
      Department(
        name: 'Coordenação de Administração de Pessoal',
        id: 'CAP',
        phoneNumber: '(91) 3212-3456',
        email: 'cap@sead.gov.br',
        location: 'DADM/SEAD',
      ),
      Department(
        name: 'Coordenação de Tecnologia da Informação',
        id: 'CTI',
        phoneNumber: '(91) 3298-7654',
        email: 'cti@sead.gov.br',
        location: 'DADM/SEAD',
      ),
    ];
  }

  List<Employee> get employees {
    return const [
      Employee(
        id: '0912153-023',
        name: 'Marina Oliveira Costa',
        role: 'Analista de Compras',
        location: 'CCO/DADM/SEAD',
      ),
      Employee(
        id: '0328112-008',
        name: 'Pedro Henrique Lima Silva',
        role: 'Assistente Administrativo',
        location: 'CCO/DADM/SEAD',
      ),
      Employee(
        id: '0765009-016',
        name: 'Ana Carolina Pereira Nunes',
        role: 'Estagiária de Contratos',
        location: 'CCO/DADM/SEAD',
      ),
      Employee(
        id: '0223098-005',
        name: 'Julia Santos Rodrigues',
        role: 'Coord. de Administração de Pessoal',
        location: 'CAP/DADM/SEAD',
      ),
      Employee(
        id: '0102030-001',
        name: 'Lucas Souza Santos',
        role: 'Assistente de R. Humanos',
        location: 'CAP/DADM/SEAD',
      ),
    ];
  }

  List<NavigationPaneItem> get items {
    return [
      PaneItem(
        key: const ValueKey('/'),
        icon: const Icon(FluentIcons.home),
        title: const Text('Início'),
        body: const SizedBox.shrink(),
      ),
      PaneItemHeader(header: const Text('Dados')),
      PaneItem(
        key: const ValueKey('/inputs/buttons'),
        icon: const Icon(FluentIcons.timeline_delivery),
        title: const Text('Diretorias'),
        body: const SizedBox.shrink(),
      ),
      PaneItem(
        key: const ValueKey('/inputs/checkbox'),
        icon: const Icon(FluentIcons.teamwork),
        title: const Text('Departamentos'),
        body: const SizedBox.shrink(),
      ),
      PaneItem(
        key: const ValueKey('/inputs/slider'),
        icon: const Icon(FluentIcons.contact_info),
        title: const Text('Servidores'),
        body: const SizedBox.shrink(),
      ),
    ];
  }

  int _selected = 0;

  int get selected => _selected;

  void updateIndex(int index) {
    _selected = index;
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _State()),
        ChangeNotifierProvider(create: (_) => _ConfigBuilder()),
      ],
      child: Consumer<_State>(
        builder: (context, state, _) {
          final AppTheme appTheme = context.read<AppTheme>();
          final int? index = state.selected;
          return NavigationView(
            //key: viewKey,
            appBar: NavigationAppBar(
              automaticallyImplyLeading: false,
              title: () {
                if (kIsWeb) {
                  return const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Gera Frequência'),
                  );
                }
                return const DragToMoveArea(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text('Gera Frequência'),
                  ),
                );
              }(),
              actions: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: ToggleSwitch(
                      content: const Text('Modo escuro'),
                      checked: FluentTheme.of(context).brightness.isDark,
                      onChanged: (v) {
                        appTheme.mode = v ? ThemeMode.dark : ThemeMode.light;
                      },
                    ),
                  ),
                ],
              ),
            ),
            paneBodyBuilder: index == null
                ? null
                : (item, child) {
                    final name = item?.key is ValueKey
                        ? (item!.key as ValueKey).value
                        : null;
                    return FocusTraversalGroup(
                      key: ValueKey('body$name'),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: switch (index) {
                          0 => _ConfigBody(),
                          1 => _Collection<Division>(
                              values: state.divisions,
                              titleBuilder: (division) => division.name,
                              subtitleBuilder: (division) =>
                                  '${division.id}/${division.companyName}',
                            ),
                          2 => _Collection<Department>(
                              values: state.departments,
                              titleBuilder: (department) => department.name,
                              subtitleBuilder: (department) =>
                                  '${department.id}/${department.location}',
                            ),
                          3 => _Collection<Employee>(
                              values: state.employees,
                              titleBuilder: (employee) => employee.name,
                              subtitleBuilder: (employee) =>
                                  '${employee.id} (${employee.location})',
                            ),
                          _ => const SizedBox.shrink(),
                        },
                      ),
                    );
                  },
            pane: NavigationPane(
              selected: state.selected,
              onChanged: (index) => state.updateIndex(index),
              displayMode: appTheme.displayMode,
              indicator: () {
                switch (appTheme.indicator) {
                  case NavigationIndicators.end:
                    return const EndNavigationIndicator();
                  case NavigationIndicators.sticky:
                  default:
                    return const StickyNavigationIndicator();
                }
              }(),
              items: state.items,
            ),
          );
        },
      ),
    );
  }
}

class _ConfigBody extends StatelessWidget {
  const _ConfigBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Selector<_ConfigBuilder, DateTime>(
          selector: (context, builder) => builder.referenceDateTime,
          builder: (context, selected, _) => DatePicker(
            header: 'Mês de referência',
            selected: selected,
            onChanged: (value) =>
                context.read<_ConfigBuilder>().referenceDateTime = value,
            showDay: false,
          ),
        ),
        const SizedBox(height: 20),
        Selector<_ConfigBuilder, String?>(
          selector: (context, builder) => builder.headerFilePath,
          builder: (context, headerFilePath, _) {
            return InfoLabel(
              label: 'Imagem de cabeçalho',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Button(
                    onPressed: () async {
                      final fp.FilePickerResult? result =
                          await fp.FilePicker.platform.pickFiles();
                      if (result == null) return;
                      if (context.mounted) {
                        context.read<_ConfigBuilder>().headerFilePath =
                            result.files.single.path;
                      }
                    },
                    child: const Text('Selecionar arquivo'),
                  ),
                  if (headerFilePath != null)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(headerFilePath),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Selector<_ConfigBuilder, bool>(
          selector: (context, builder) => builder.fill,
          builder: (context, fill, _) {
            return Checkbox(
              checked: fill,
              onChanged: (value) {
                if (value == null) return;
                context.read<_ConfigBuilder>().fill = value;
              },
              content: const Row(
                children: [
                  Text('Enforcar'),
                  SizedBox(width: 10),
                  Tooltip(
                    displayHorizontally: true,
                    useMousePosition: false,
                    style: TooltipThemeData(
                      preferBelow: true,
                    ),
                    message: 'Se segundas e sextas-feiras '
                        'devem ser consideradas\ncomo '
                        'facultadas caso hajam feriados '
                        'nas terças e\nquintas-feiras, '
                        'respectivamente.',
                    child: Icon(FluentIcons.info, size: 15),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        FilledButton(
          child: const Text('gerar arquivo'),
          onPressed: () async {
            final _State state = context.read<_State>();
            final Config config = context.read<_ConfigBuilder>().config;
            final Uint8List bytes = await createTimesheet(
              config: config,
              allDivisions: state.divisions,
              allDepartments: state.departments,
              allEmployees: state.employees,
            );

            final String? path = await FileSaver.instance.saveAs(
              name:
                  'Frequencia-${DateFormat('yyyy_MM').format(DateTime(config.year, config.month))}',
              bytes: bytes,
              ext: '.pdf',
              mimeType: MimeType.pdf,
            );
            if (path == null) return;

            final File file = File(path);
            await file.writeAsBytes(bytes);
          },
        ),
      ],
    );
  }
}

class _ConfigBuilder extends ChangeNotifier {
  DateTime _referenceDateTime = DateTime.now();

  DateTime get referenceDateTime => _referenceDateTime;

  set referenceDateTime(DateTime value) {
    _referenceDateTime = value;
    notifyListeners();
  }

  String? _headerFilePath;

  String? get headerFilePath => _headerFilePath;

  set headerFilePath(String? value) {
    _headerFilePath = value;
    notifyListeners();
  }

  bool _fill = false;

  bool get fill => _fill;

  set fill(bool value) {
    _fill = value;
    notifyListeners();
  }

  Config get config {
    return Config(
      year: referenceDateTime.year,
      month: referenceDateTime.month,
      headerPath: headerFilePath,
      fill: fill,
    );
  }
}

class _Collection<T> extends StatelessWidget {
  final List<T> values;
  final String Function(T) titleBuilder;
  final String Function(T) subtitleBuilder;

  const _Collection({
    required this.values,
    required this.titleBuilder,
    required this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TextEditingController>(
      create: (_) => TextEditingController(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 300,
                child: Consumer<TextEditingController>(
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(FluentIcons.search, size: 10),
                  ),
                  builder: (context, controller, child) {
                    return TextBox(
                      controller: controller,
                      placeholder: 'Pesquisar',
                      suffix: child,
                    );
                  },
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              FilledButton(
                child: const Text('adicionar'),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer<TextEditingController>(
              builder: (context, controller, _) {
                final String query = controller.text.trim().toLowerCase();
                final List<T> values = query.isEmpty
                    ? this.values
                    : this.values.where((value) {
                        final String name =
                            titleBuilder(value).trim().toLowerCase();
                        return name.contains(query);
                      }).toList();
                return ListView.separated(
                  itemCount: values.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 5),
                  itemBuilder: (context, i) {
                    final T value = values[i];
                    return Card(
                      child: ListTile(
                        title: Text(titleBuilder(value)),
                        subtitle: Text(subtitleBuilder(value)),
                        trailing: Row(
                          children: [
                            FilledButton(
                              onPressed: () {},
                              child: const Text('editar'),
                            ),
                            const SizedBox(width: 15),
                            Button(
                              onPressed: () {},
                              child: const Text('excluir'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
