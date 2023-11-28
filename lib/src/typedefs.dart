typedef ParserResult<T extends Object> = (T?, String);

typedef ParseContext = Map<String, Object?>;

typedef CustomParse<T extends Object> = ParserResult<T> Function(
  String input, {
  ParseContext? context,
});
