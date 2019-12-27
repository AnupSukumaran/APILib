import XCTest
@testable import APILib

final class APILibTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(APILib().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
