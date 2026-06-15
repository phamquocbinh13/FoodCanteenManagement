import '../usecases/session/create_session_use_case.dart';
import '../../../data/datasources/session/session_engine_datasource.dart';

/// Bridges daily sequence counter from datasource into use cases.
final class DatasourceDailySequence
    implements SessionEngineDataSourceDailySequence {
  DatasourceDailySequence(this._dataSource);

  final SessionEngineDataSource _dataSource;

  @override
  int nextDailySequence(String dateKey) {
    return _dataSource.nextDailySequence(dateKey);
  }
}
