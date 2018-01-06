// Copyright Benoit Blanchon 2014-2016
// MIT License
//
// Arduino JSON library
// https://github.com/bblanchon/ArduinoJson
// If you like this project, please add a star!

#pragma once

#include "IndentedPrint.hpp"

namespace ArduinoJson {
namespace Internals {

// Converts a compact JSON string into an indented one.
class Prettyfier : public Print {
 public:
  explicit Prettyfier(IndentedPrint& p) : _sink(p) {
    _previousChar = 0;
    _inString = false;
  }

  virtual size_t write(uint8_t c) {
    size_t n = _inString ? handleStringChar(c) : handleMarkupChar(c);
    _previousChar = c;
    return n;
  }

 private:
  Prettyfier& operator=(const Prettyfier&);  // cannot be assigned

  bool inEmptyBlock() {
    return _previousChar == '{' || _previousChar == '[';
  }

  size_t handleStringChar(uint8_t c) {
    bool isQuote = c == '"' && _previousChar != '\\';

    if (isQuote) _inString = false;

    return _sink.write(c);
  }

  size_t handleMarkupChar(uint8_t c) {
    switch (c) {
      case '{':
      case '[':
        return writeBlockOpen(c);

      case '}':
      case ']':
        return writeBlockClose(c);

      case ':':
        return writeColon();

      case ',':
        return writeComma();

      case '"':
        return writeQuoteOpen();

      default:
        return writeNormalChar(c);
    }
  }

  size_t writeBlockClose(uint8_t c) {
    return unindentIfNeeded() + _sink.write(c);
  }

  size_t writeBlockOpen(uint8_t c) {
    return indentIfNeeded() + _sink.write(c);
  }

  size_t writeColon() {
    return _sink.write(':') + _sink.write(' ');
  }

  size_t writeComma() {
    return _sink.write(',') + _sink.println();
  }

  size_t writeQuoteOpen() {
    _inString = true;
    return indentIfNeeded() + _sink.write('"');
  }

  size_t writeNormalChar(uint8_t c) {
    return indentIfNeeded() + _sink.write(c);
  }

  size_t indentIfNeeded() {
    if (!inEmptyBlock()) return 0;

    _sink.indent();
    return _sink.println();
  }

  size_t unindentIfNeeded() {
    if (inEmptyBlock()) return 0;

    _sink.unindent();
    return _sink.println();
  }

  uint8_t _previousChar;
  IndentedPrint& _sink;
  bool _inString;
};
}
}
