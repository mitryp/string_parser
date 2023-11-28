import '../typedefs.dart';

/// Whether the given [ParserResult] has a result.
bool isSuccess<T extends Object>(ParserResult<T> res) => res.$1 != null;

/// Whether the given [ParserResult] does not have a result.
bool isFailure<T extends Object>(ParserResult<T> res) => res.$1 == null;
