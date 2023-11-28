part of 'parser.dart';

extension ParserMatches<T extends Object> on Parser<T> {
  bool matchesAsPrefix(String input) => parse(input).$1 != null;

  bool matchesCompletely(String input) => switch (parse(input)) {
        (_?, '') => true,
        _ => false,
      };
}

extension ParserFactories<T extends Object> on Parser<T> {
  /// Returns a parser which return the [T] result of this parser, but expects the [other] parser to
  /// parse successfully.
  /// The rest of the string in the [ParserResult] will be used from the result of the other parser.
  Parser<T> followedBy(Parser<T> other) => _FollowedByParser(this, other);

  /// Returns a parser which return the [T] result of the [other] parser, but expects this parser to
  /// parse successfully.
  /// The rest of the string in the [ParserResult] will be used from the result of this parser.
  Parser<T> precededBy(Parser<T> other) => _PrecededByParser(this, other);

  /// An alias operator for [followedBy] method.
  /// Refer to its documentation for more information.
  Parser<T> operator <<(Parser<T> other) => followedBy(other);

  /// Expects this parser to parse successfully and then returns the result of the [other] parser.
  Parser<T> operator >>(Parser<T> other) => precededBy(other);

  /// The returned parser tries to parse with this parser.
  /// If not successful, tries to parse with the [other] parser.
  Parser<T> operator |(Parser<T> other) => _OrParser(this, other);

  /// Returns a parser which will parse with this parser as long as it returns a result.
  ///
  /// Setting the [unsafe] flag to true will disable the limit of 100000 iterations.
  /// Be cautious, as this may lead to infinite loops and severely increased memory usage.
  Parser<List<T>> many({bool unsafe = false}) => _ManyParser(this, unsafe: unsafe);
}
