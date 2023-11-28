import 'package:parser/parser.dart';

void main() {
  final parser = (Parser.builder<num>()
        ..then(Parser.string(RegExp(r'\s*')))
        ..then(Parser.number(), withKey: Parser.resultKey))
      .build();

  print(parser.parse('   3112<3'));
}
