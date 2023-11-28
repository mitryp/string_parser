import '../errors.dart';
import '../typedefs.dart';
import '../utils/result_predicates.dart';

part 'extensions.dart';
part 'builder.dart';
part 'parse_driver.dart';
part 'parser_impl.dart';

abstract class Parser<T extends Object> {
  /// A key which is used by [ParseDriver] to extract the final result of parsing from the context.
  static const String resultKey = '__res';

  /// Returns a [ParserBuilder] which allows to chain multiple parser and share a single context
  /// between them, allowing to parse complex objects.
  ///
  /// For more information about the [ParseContext], refer to its docs and the docs of
  /// [ParseDriver].
  static ParserBuilder<T> builder<T extends Object>() => ParserBuilder();

  /// Creates a parser that returns a string matched by the [pattern].
  ///
  /// The [pattern] can be a [RegExp] or [String].
  /// If the pattern is String, by-character check against the input prefix will be performed.
  static Parser<String> string(Pattern pattern) => _StringParser(pattern);

  /// Creates a parser which parser that parses any number in the beginning of the input.
  /// It can handle either [double] or [int].
  // ignore: unnecessary_cast
  static Parser<num> number() => (_DoubleParser() as Parser<num>) | _IntParser();

  static Parser<T> custom<T extends Object>(CustomParse<T> parse) => _FunctionParser(parse);

  static Parser<T> context<T extends Object>(T? Function(ParseContext context) fn) =>
      _ContextParser(fn);

  final String? _driverKey;

  const Parser({String? driverKey}) : _driverKey = driverKey;

  /// Tries to parse the given [input] and returns a pair of T? and the rest of the given string.
  ParserResult<T> parse(String input, {ParseContext? context});

  ParserResult<T> _setRes(ParseContext? context, ParserResult<T> res) {
    final key = _driverKey;

    if (key == null) {
      return res;
    }

    context?[key] = res.$1;

    return res;
  }
}
