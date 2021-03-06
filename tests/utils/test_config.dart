// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#library("utils_test_config");

#import("../../tools/testing/dart/test_suite.dart");

class UtilsTestSuite extends StandardTestSuite {
  UtilsTestSuite(Map configuration)
      : super(configuration,
              "utils",
              "tests/utils/src",
              ["tests/utils/utils.status"]);
}
