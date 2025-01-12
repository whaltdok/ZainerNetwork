// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gcloud/service_scope.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'package:pub_dev/analyzer/pana_runner.dart';
import 'package:pub_dev/dartdoc/dartdoc_runner.dart';
import 'package:pub_dev/fake/backend/fake_dartdoc_runner.dart';
import 'package:pub_dev/fake/backend/fake_pana_runner.dart';
import 'package:pub_dev/frontend/static_files.dart';
import 'package:pub_dev/service/services.dart';
import 'package:pub_dev/tool/test_profile/import_source.dart';
import 'package:pub_dev/tool/test_profile/importer.dart';
import 'package:pub_dev/tool/test_profile/models.dart';

import '../server/local_server_state.dart';

/// Initialize fake server's local data.
class FakeInitDataFileCommand extends Command {
  @override
  String get description => 'Initialize local data fro fake server.';

  @override
  String get name => 'init-data-file';

  FakeInitDataFileCommand() {
    argParser
      ..addOption('test-profile',
          help: 'The file to read the test profile from.')
      ..addOption(
        'source',
        allowed: ['pub.dev', 'fake'],
        help: 'Download package content from pub.dev or create fake sources.',
        defaultsTo: 'pub.dev',
      )
      ..addOption(
        'analysis',
        allowed: ['none', 'fake', 'real'],
        help: 'Analyze the package with fake or real analysis.',
        defaultsTo: 'none',
      )
      ..addOption('data-file', help: 'The file to store the local state.');
  }

  @override
  Future<void> run() async {
    Logger.root.onRecord.listen((r) {
      print([
        r.time.toIso8601String(),
        r.toString(),
        r.error,
        r.stackTrace?.toString(),
      ].where((e) => e != null).join(' '));
    });

    final analysis = argResults!['analysis'] as String;
    final source = argResults!['source'] as String;
    final dataFile = argResults!['data-file'] as String;
    final profile = TestProfile.fromYaml(
      await File(argResults!['test-profile'] as String).readAsString(),
    );

    final archiveCachePath = p.join(
      resolveAppDir(),
      '.dart_tool',
      'pub-test-profile',
      'archives',
    );

    final state = LocalServerState();

    await withFakeServices(
        datastore: state.datastore,
        storage: state.storage,
        fn: () async {
          // ignore: invalid_use_of_visible_for_testing_member
          await importProfile(
            profile: profile,
            source: source == 'pub.dev'
                ? ImportSource.fromPubDev(archiveCachePath: archiveCachePath)
                : ImportSource.autoGenerated(),
          );

          if (analysis == 'real') {
            await _analyze();
          } else if (analysis == 'fake') {
            await processJobsWithFakePanaRunner();
            await processJobsWithFakeDartdocRunner();
          }
        });
    await state.save(dataFile);
  }
}

Future<void> _analyze() async {
  await fork(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    await processJobsWithPanaRunner();
    // ignore: invalid_use_of_visible_for_testing_member
    await processJobsWithDartdocRunner();
  });
}
