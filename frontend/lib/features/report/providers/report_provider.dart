import 'package:jeju_together/core/network/dio_provider.dart';
import 'package:jeju_together/features/report/data/report_api.dart';
import 'package:jeju_together/features/report/data/report_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_provider.g.dart';

@riverpod
ReportApi reportApi(ReportApiRef ref) => ReportApi(ref.watch(dioProvider));

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) =>
    ReportRepository(ref.watch(reportApiProvider));
