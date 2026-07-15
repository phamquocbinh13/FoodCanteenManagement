// Application mapper contracts.
//
// Nest → domain wire parsing lives in `lib/data/mappers/remote_json.dart`
// and is used by every Remote*Repository. Typed bidirectional mappers
// below remain optional scaffolding for a future DTO layer.
export 'batch_mapper.dart';
export 'mapper.dart';
export 'menu_mapper.dart';
export 'payment_mapper.dart';
export 'session_mapper.dart';
export 'user_mapper.dart';
