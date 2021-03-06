// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class StringMatch implements Match {
  const StringMatch(int this._start,
                    String this.str,
                    String this.pattern);

  int start() => _start;
  int end() => _start + pattern.length;
  String operator[](int g) => group(g);
  int groupCount() => 0;

  String group(int group_) {
    if (group_ != 0) {
      throw new IndexOutOfRangeException(group_);
    }
    return pattern;
  }

  List<String> groups(List<int> groups_) {
    List<String> result = new List<String>();
    for (int g in groups_) {
      result.add(group(g));
    }
    return result;
  }

  final int _start;
  final String str;
  final String pattern;
}

allMatchesInStringUnchecked(receiver, str) {
  var result = new List();
  var length = receiver.length;
  if (length === 0) {
    return result;
  }

  var strLength = str.length;
  for (var i = 0; i < strLength;) {
    var index = str.indexOf(receiver, i);
    if (index < 0) {
      return result;
    }
    result.add(new StringMatch(index, str, receiver));
    i = index + length;
  }
  return result;
}

stringContainsUnchecked(receiver, other, startIndex) {
  if (other is String) {
    return receiver.indexOf(other, startIndex) !== -1;
  } else if (other is RegExp) {
    return other.hasMatch(receiver.substring(startIndex));
  } else {
    var substr = receiver.substring(startIndex);
    return other.allMatches(substr).iterator().hasNext();
  }
}

stringReplaceAllUnchecked(receiver, from, to) {
  if (from is String) {
    if (from == "") {
      if (receiver == "") {
        return to;
      } else {
        StringBuffer result = new StringBuffer();
        int length = receiver.length;
        result.add(to);
        for (int i = 0; i < length; i++) {
          result.add(receiver[i]);
          result.add(to);
        }
        return result.toString();
      }
    } else {
      var quoter =
        new RegExpWrapper(@'[-[\]{}()*+?.,\\^$|#\s]', false, false, true).re;
      var quoted = JS('String', @'$0.replace($1, "\\$&")', from, quoter);
      var re = new RegExpWrapper(quoted, false, false, true).re;
      return JS('String', @'$0.replace($1, $2)', receiver, re, to);
    }
  } else if (from is RegExp) {
    var re = new RegExpWrapper.fromRegExp(from, true).re;
    return JS('String', @'$0.replace($1, $2)', receiver, re, to);
  } else {
    // TODO(floitsch): implement generic String.replace (with patterns).
    throw "StringImplementation.replaceAll(Pattern) UNIMPLEMENTED";
  }
}

stringReplaceFirstUnchecked(receiver, from, to) {
  if (from is String) {
    return JS('String', @'$0.replace($1, $2)', receiver, from, to);
  } else if (from is RegExp) {
    var re = new RegExpWrapper.fromRegExp(from, false).re;
    return JS('String', @'$0.replace($1, $2)', receiver, re, to);
  } else {
    // TODO(floitsch): implement generic String.replace (with patterns).
    throw "StringImplementation.replace(Pattern) UNIMPLEMENTED";
  }
}

stringSplitUnchecked(receiver, pattern) {
  if (pattern is String) {
    return JS('List', @'$0.split($1)', receiver, pattern);
  } else if (pattern is RegExp) {
    var re = new RegExpWrapper.fromRegExp(pattern, false).re;
    return JS('List', @'$0.split($1)', receiver, re);
  } else {
    throw "StringImplementation.split(Pattern) UNIMPLEMENTED";
  }
}
