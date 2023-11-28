part of 'parser.dart';

class ParserBuilder<T extends Object> {
  final List<Parser> _parsers = [];

  ParserBuilder();

  void then(Parser next, {String? withKey}) {
    final driverKey = withKey;
    Parser parser = next;

    if (driverKey != null && next._driverKey == null || next._driverKey != driverKey) {
      parser = _ProxyParser(next, driverKey: driverKey);
    }

    _parsers.add(parser);
  }

  Parser<T> build() => ParseDriver(_parsers);
}
