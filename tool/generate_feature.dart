///
/// Feature scaffold generator.
/// Creates full feature structure with boilerplate code.
/// Usage:
///   dart run tool/generate_feature.dart auth
///   dart run tool/generate_feature.dart product --no-freezed
///
library;

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty || args.first.startsWith('--')) {
    FeatureGenerator._printUsage();
    return;
  }

  final featureName = args.first.toLowerCase();
  final noFreezed = args.contains('--no-freezed');
  final withList = args.contains('--with-list') || args.contains('--list');
  final withDetail = args.contains('--with-detail') || args.contains('--detail');

  final generator = FeatureGenerator(
    name: featureName,
    useFreezed: !noFreezed,
    includeList: withList,
    includeDetail: withDetail,
  );

  generator.run();
}

class FeatureGenerator {
  FeatureGenerator({
    required String name,
    required this.useFreezed,
    required this.includeList,
    required this.includeDetail,
  }) : _name = name,
       _pascalName = _toPascal(name),
       _capitalName = _toCapital(name);

  final String _name;
  final String _pascalName;
  final String _capitalName;
  final bool useFreezed;
  final bool includeList;
  final bool includeDetail;

  late final String _basePath = 'lib/features/$_name';

  static String _toPascal(String s) {
    return s.split('_').map((p) => p[0].toUpperCase() + p.substring(1)).join();
  }

  static String _toCapital(String s) {
    return s[0].toUpperCase() + s.substring(1);
  }

  void run() {
    print('\n📁  Generating feature: $_name');
    print('    $_basePath/\n');

    _createDir('data/datasources');
    _createDir('data/models');
    _createDir('data/repositories');
    _createDir('domain/entities');
    _createDir('domain/repositories');
    _createDir('presentation/providers');
    _createDir('presentation/pages');
    _createDir('presentation/widgets');

    _writeFile('data/datasources/${_name}_remote_datasource.dart', _remoteDatasource());
    _writeFile('data/datasources/${_name}_local_datasource.dart', _localDatasource());
    _writeFile('data/models/${_name}_dto.dart', _dto());
    _writeFile('data/repositories/${_name}_repository_impl.dart', _repositoryImpl());
    _writeFile('domain/entities/$_name.dart', _entity());
    _writeFile('domain/repositories/${_name}_repository.dart', _repositoryInterface());
    _writeFile('presentation/providers/${_name}_provider.dart', _provider());
    _writeFile('presentation/pages/${_name}_page.dart', _page());
    _writeFile('$_name.dart', _barrel());

    if (includeList) {
      _writeFile('presentation/pages/${_name}_list_page.dart', _listPage());
    }
    if (includeDetail) {
      _writeFile('presentation/pages/${_name}_detail_page.dart', _detailPage());
    }

    print('\n✅  Feature $_name generated successfully!\n');
  }

  // ── File templates ──

  String _remoteDatasource() => '''
import 'package:dio/dio.dart';
import 'package:mastertool/core/constants/endpoints.dart';
import 'package:mastertool/core/utils/logger.dart';

abstract class ${_pascalName}RemoteDataSource {
  // Future<${_pascalName}Dto> get${_pascalName}(String id);
}

class ${_pascalName}RemoteDataSourceImpl implements ${_pascalName}RemoteDataSource {
  const ${_pascalName}RemoteDataSourceImpl(this._dio);

  final Dio _dio;
}
''';

  String _localDatasource() => '''
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ${_pascalName}LocalDataSource {
  // Future<${_pascalName}Dto?> getCached${_pascalName}();
}

class ${_pascalName}LocalDataSourceImpl implements ${_pascalName}LocalDataSource {
  const ${_pascalName}LocalDataSourceImpl(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'cached_${_name}';
}
''';

  String _dto() {
    if (!useFreezed) return '''
class ${_pascalName}Dto {
  const ${_pascalName}Dto({
    required this.id,
  });

  final String id;

  factory ${_pascalName}Dto.fromJson(Map<String, dynamic> json) {
    return ${_pascalName}Dto(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id};
}
''';

    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${_name}_dto.freezed.dart';
part '${_name}_dto.g.dart';

@freezed
class ${_pascalName}Dto with _\$${_pascalName}Dto {
  const factory ${_pascalName}Dto({
    required String id,
    @Default('') String name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _\$${_pascalName}Dto;

  factory ${_pascalName}Dto.fromJson(Map<String, dynamic> json) =>
      _\$${_pascalName}DtoFromJson(json);
}
''';
  }

  String _entity() {
    if (!useFreezed) return '''
class $_pascalName {
  const $_pascalName({
    required this.id,
  });

  final String id;
}
''';

    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '$_name.freezed.dart';

@freezed
class $_pascalName with _\$${_pascalName} {
  const factory $_pascalName({
    required String id,
    required String name,
    DateTime? createdAt,
  }) = _\$${_pascalName};
}
''';
  }

  String _repositoryInterface() => '''
import 'package:mastertool/core/error/result.dart';
import 'package:mastertool/features/$_name/domain/entities/$_name.dart';

abstract class ${_pascalName}Repository {
  // Future<Result<$_pascalName>> getById(String id);
}
''';

  String _repositoryImpl() => '''
import 'package:mastertool/core/error/result.dart';
import 'package:mastertool/core/utils/logger.dart';
import 'package:mastertool/features/$_name/data/datasources/${_name}_remote_datasource.dart';
import 'package:mastertool/features/$_name/data/datasources/${_name}_local_datasource.dart';
import 'package:mastertool/features/$_name/data/models/${_name}_dto.dart';
import 'package:mastertool/features/$_name/domain/entities/$_name.dart';
import 'package:mastertool/features/$_name/domain/repositories/${_name}_repository.dart';

class ${_pascalName}RepositoryImpl implements ${_pascalName}Repository {
  const ${_pascalName}RepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ${_pascalName}RemoteDataSource remoteDataSource;
  final ${_pascalName}LocalDataSource localDataSource;

  // @override
  // Future<Result<$_pascalName>> getById(String id) async {
  //   try {
  //     AppLogger.info('Fetching $_name by id: \$id', tag: '${_pascalName}Repo');
  //     final dto = await remoteDataSource.get${_pascalName}(id);
  //     return Success(_mapToEntity(dto));
  //   } catch (e, stack) {
  //     AppLogger.error('Failed to fetch $_name', error: e, stack: stack, tag: '${_pascalName}Repo');
  //     return Failure(mapErrorToFailure(e));
  //   }
  // }

  // $_pascalName _mapToEntity(${_pascalName}Dto dto) => $_pascalName(id: dto.id, name: dto.name);
}
''';

  String _provider() => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mastertool/core/utils/logger.dart';
import 'package:mastertool/features/$_name/domain/entities/$_name.dart';
import 'package:mastertool/features/$_name/domain/repositories/${_name}_repository.dart';

// final ${_name}RepositoryProvider = Provider<${_pascalName}Repository>((ref) {
//   throw UnimplementedError('Inject repository implementation');
// });

final ${_name}ControllerProvider =
    FutureProvider.family<$_pascalName?, String>((ref, id) async {
  AppLogger.info('Building $_pascalName controller for \$id', tag: '${_pascalName}Ctrl');
  // final repo = ref.read(${_name}RepositoryProvider);
  // final result = await repo.getById(id);
  // return result.when((data) => data, (failure) => throw failure);
  return null;
});
''';

  String _page() => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${_pascalName}Page extends ConsumerWidget {
  const ${_pascalName}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('$_capitalName')),
      body: const Center(child: Text('$_capitalName Page')),
    );
  }
}
''';

  String _listPage() => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${_pascalName}ListPage extends ConsumerWidget {
  const ${_pascalName}ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('${_capitalName}s')),
      body: ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) => const ListTile(title: Text('Item')),
      ),
    );
  }
}
''';

  String _detailPage() => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${_pascalName}DetailPage extends ConsumerWidget {
  const ${_pascalName}DetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('$_capitalName Detail')),
      body: Center(child: Text('$_capitalName: \$id')),
    );
  }
}
''';

  String _barrel() => '''
export 'data/datasources/${_name}_remote_datasource.dart';
export 'data/datasources/${_name}_local_datasource.dart';
export 'data/models/${_name}_dto.dart';
export 'data/repositories/${_name}_repository_impl.dart';
export 'domain/entities/$_name.dart';
export 'domain/repositories/${_name}_repository.dart';
export 'presentation/providers/${_name}_provider.dart';
export 'presentation/pages/${_name}_page.dart';
''';

  // ── Filesystem helpers ──

  void _createDir(String path) {
    final dir = Directory('$_basePath/$path');
    dir.createSync(recursive: true);
    print('   📂  $_name/$path/');
  }

  void _writeFile(String path, String content) {
    final file = File('$_basePath/$path');
    if (file.existsSync()) {
      print('   ⚠️   $_name/$path — already exists, skipping');
      return;
    }
    file.createSync(recursive: true);
    file.writeAsStringSync(content.trimLeft());
    print('   📄  $_name/$path');
  }

  static void _printUsage() {
    print('''
Usage: dart run tool/generate_feature.dart <feature_name> [options]

Options:
  --no-freezed      Generate plain Dart classes instead of @freezed
  --with-list       Include list page
  --with-detail     Include detail page with ID parameter

Examples:
  dart run tool/generate_feature.dart auth
  dart run tool/generate_feature.dart product --with-list --with-detail
  dart run tool/generate_feature.dart profile --no-freezed
''');
  }
}
