part of 'parser.dart';

class ParseDriver<T extends Object> extends Parser<T> {
  final ParseContext _context = {};
  final List<Parser> _parsers;

  ParseDriver(this._parsers);

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) {
    context ??= _context;

    context.clear();
    var restString = input;

    for (final parser in _parsers) {
      final res = parser.parse(restString, context: context);
      final (t, rest) = res;

      if (isFailure(res)) {
        return (null, input);
      }

      restString = rest;

      final key = parser._driverKey;
      if (key != null) {
        context[key] = t;
      }
    }

    final res = context[Parser.resultKey];

    return (res is T? ? res : null, restString);
  }
}
