import XCTest
@testable import Term

final class TermTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Term().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
