import XCTest
@testable import SystemKit

final class SystemKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SystemKit().text, "Hello, World!")
    }
}
