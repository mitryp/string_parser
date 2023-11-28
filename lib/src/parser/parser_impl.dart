part of 'parser.dart';

/// A parser used to assign a [driverKey] to the parser which does not have one.
class _ProxyParser<T extends Object> extends Parser<T> {
  final Parser<T> _parser;

  const _ProxyParser(this._parser, {super.driverKey});

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) =>
      _parser.parse(input, context: context);
}

/// A parser that returns the result of the first successful parse, starting with the [_first], and
/// then moving to the [second].
class _OrParser<T extends Object> extends Parser<T> {
  final Parser<T> _first;
  final Parser<T> second;

  const _OrParser(this._first, this.second, {super.driverKey});

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) {
    final firstRes = _first.parse(input);

    if (isSuccess(firstRes)) {
      return _setRes(context, firstRes);
    }

    return _setRes(context, second.parse(input));
  }
}

/// A parser that uses the [first] parser, and then returns the result of the [second] parser on the
/// rest of the string.
class _PrecededByParser<T extends Object> extends Parser<T> {
  final Parser<T> first;
  final Parser<T> second;

  _PrecededByParser(this.first, this.second, {super.driverKey});

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) {
    final (t1, rest) = first.parse(input);

    if (t1 == null) {
      return (null, input);
    }

    return _setRes(context, second.parse(rest));
  }
}

/// A parser that returns the result of the [_first] parser, but expects the [follower] to parse
/// successfully as well.
/// The rest of the string will be extracted from the [follower] result.
class _FollowedByParser<T extends Object> extends Parser<T> {
  final Parser<T> parser;
  final Parser<T> follower;

  _FollowedByParser(this.parser, this.follower, {super.driverKey});

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) {
    final res = parser.parse(input);

    if (isFailure(res)) {
      return (null, input);
    }

    final followerRes = follower.parse(res.$2);

    if (isFailure(followerRes)) {
      return (null, input);
    }

    return _setRes(context, (res.$1, followerRes.$2));
  }
}

class _StringParser extends Parser<String> {
  final Pattern pattern;

  const _StringParser(this.pattern);

  @override
  ParserResult<String> parse(String input, {ParseContext? context}) {
    final match = pattern.matchAsPrefix(input);

    if (match == null) {
      return (null, input);
    }

    return _setRes(
      context,
      (
        match.group(0) ?? (throw StateError('Group 0 in match is null')),
        input.substring(match.end),
      ),
    );
  }
}

class _IntParser extends Parser<int> {
  static final Parser<String> _intStringParser = _StringParser(RegExp(r'\d+'));

  const _IntParser();

  @override
  ParserResult<int> parse(String input, {ParseContext? context}) {
    final (res, rest) = _intStringParser.parse(input);

    if (res == null) {
      return (null, input);
    }

    return _setRes(context, (int.parse(res), rest));
  }
}

class _DoubleParser extends Parser<double> {
  static final Parser<String> _doubleStringParser = _StringParser(RegExp(r'(\d+\.\d*)|(\d*\.\d+)'));

  const _DoubleParser();

  @override
  ParserResult<double> parse(String input, {ParseContext? context}) {
    final (res, rest) = _doubleStringParser.parse(input);

    if (res == null) {
      return (null, input);
    }

    return _setRes(context, (double.tryParse(res), rest));
  }
}

class _ContextParser<T extends Object> extends Parser<T> {
  final T? Function(ParseContext context) _getter;

  const _ContextParser(this._getter, {super.driverKey});

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) {
    final res = context != null ? _getter(context) : null;

    return _setRes(context, (res, input));
  }
}

class _ManyParser<T extends Object> extends Parser<List<T>> {
  static const int _limit = 100000;

  final Parser<T> _parser;
  final bool _isUnsafe;

  const _ManyParser(this._parser, {bool unsafe = false}) : _isUnsafe = unsafe;

  @override
  ParserResult<List<T>> parse(String input, {ParseContext? context}) {
    final list = <T>[];
    var restString = input;

    for (var i = 0;; i++) {
      if (!_isUnsafe && i >= _limit) {
        throw InfiniteParseError();
      }

      final (res, rest) = _parser.parse(restString);

      if (res == null) {
        break;
      }

      restString = rest;
      list.add(res);
    }

    return _setRes(context, (list, restString));
  }
}

class _FunctionParser<T extends Object> extends Parser<T> {
  final CustomParse<T> _parse;

  const _FunctionParser(this._parse);

  @override
  ParserResult<T> parse(String input, {ParseContext? context}) =>
      _setRes(context, _parse(input, context: context));
}
