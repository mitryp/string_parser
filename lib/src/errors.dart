class InfiniteParseError extends Error {
  InfiniteParseError();

  @override
  String toString() => 'Infinite parse: Parser exceeded the limit of iterations. '
      'Consider revising the pattern, as it may cause the infinite loop. '
      'If you are dealing with data of extreme sizes and it is not the case, please use `unsafe` '
      'flag.';
}
