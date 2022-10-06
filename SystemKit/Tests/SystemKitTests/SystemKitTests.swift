import XCTest
import Beltex
@testable import SystemKit

final class SystemKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
 
        print(System.CPUPowerLimit())
        XCTAssertEqual(SystemKit().label, "Hello, World!")
    }
}
