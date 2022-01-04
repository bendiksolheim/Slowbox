import XCTest

import TermTests

var tests = [XCTestCaseEntry]()
tests += SlowboxTests.allTests()
XCTMain(tests)
