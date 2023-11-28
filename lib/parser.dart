/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

export 'src/errors.dart' show InfiniteParseError;
export 'src/parser/parser.dart' show Parser, ParserBuilder, ParserFactories, ParserMatches;
export 'src/typedefs.dart' show ParserResult, CustomParse, ParseContext;
export 'src/utils/result_predicates.dart' show isSuccess, isFailure;
