// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:example/json_converter_example.dart';
import 'package:test/test.dart';

void main() {
  test('trivial case', () {
    var collection = GenericCollection<int>(
        page: 0, totalPages: 3, totalResults: 10, results: [1, 2, 3]);

    var encoded = _encode(collection);
    var collection2 = GenericCollection<int>.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>);

    expect(collection2.results, [1, 2, 3]);

    expect(_encode(collection2), encoded);
  });

  test('custom result', () {
    var collection = GenericCollection<CustomResult>(
        page: 0,
        totalPages: 3,
        totalResults: 10,
        results: [CustomResult('bob', 42)]);

    var encoded = _encode(collection);
    var collection2 = GenericCollection<CustomResult>.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>);

    expect(collection2.results, [CustomResult('bob', 42)]);

    expect(_encode(collection2), encoded);
  });

  test('mixed values in generic collection', () {
    var collection =
        GenericCollection(page: 0, totalPages: 3, totalResults: 10, results: [
      1,
      3.14,
      null,
      'bob',
      ['list'],
      {'map': 'map'},
      CustomResult('bob', 42)
    ]);

    var encoded = _encode(collection);

    expect(
        () => GenericCollection<CustomResult>.fromJson(
            jsonDecode(encoded) as Map<String, dynamic>),
        _throwsCastSomething);
    expect(
        () => GenericCollection<int>.fromJson(
            jsonDecode(encoded) as Map<String, dynamic>),
        _throwsCastSomething);
    expect(
        () => GenericCollection<String>.fromJson(
            jsonDecode(encoded) as Map<String, dynamic>),
        _throwsCastSomething);

    var collection2 =
        GenericCollection.fromJson(jsonDecode(encoded) as Map<String, dynamic>);

    expect(collection2.results, [
      1,
      3.14,
      null,
      'bob',
      ['list'],
      {'map': 'map'},
      CustomResult('bob', 42)
    ]);

    expect(_encode(collection2), encoded);
  });
}

final _throwsCastSomething = throwsA(const TypeMatcher<CastError>());

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);
