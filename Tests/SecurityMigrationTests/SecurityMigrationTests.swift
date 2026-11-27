// Copyright © 2026 Universal SystemKit. All rights reserved.

import CommonCrypto
import Foundation
import SystemKit_Objc
import XCTest

private enum CipherError: Error {
    case invalidInput
    case operationFailed(CCCryptorStatus)
}

// The byte-oriented implementation accepts the actual AES key and IV.
private func crypt(_ operation: CCOperation, key: Data, iv: Data, input: Data) throws -> Data {
    guard [16, 24, 32].contains(key.count), iv.count == 16 else { throw CipherError.invalidInput }
    let capacity = input.count + kCCBlockSizeAES128
    var output = Data(count: capacity)
    var length = 0
    let status = key.withUnsafeBytes { keyBytes in
        iv.withUnsafeBytes { ivBytes in
            input.withUnsafeBytes { inputBytes in
                output.withUnsafeMutableBytes { outputBytes in
                    CCCrypt(operation, CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding),
                            keyBytes.baseAddress, key.count, ivBytes.baseAddress,
                            inputBytes.baseAddress, input.count, outputBytes.baseAddress, capacity, &length)
                }
            }
        }
    }
    guard status == kCCSuccess else { throw CipherError.operationFailed(status) }
    return Data(output.prefix(length))
}

final class SecurityMigrationTests: XCTestCase {
    func testIndependentPaddedAESVector() throws {
        let result = try crypt(CCOperation(kCCEncrypt), key: Data(repeating: 0, count: 16),
                               iv: Data(repeating: 0, count: 16), input: Data())
        XCTAssertEqual(result.map { String(format: "%02x", $0) }.joined(), "0143db63ee66b0cdff9f69917680151e")
    }

    func testLegacyCiphertexts() throws {
        let legacy = SKSecurity.shared()
        for (size, kind) in [(16, SKSecurityAESType.AES128), (24, .AES192), (32, .AES256)] {
            let key = String(repeating: "a", count: size - 1)
            let iv = "0123456789abcde"
            let keyBytes = Data(key.utf8) + Data([0])
            let ivBytes = Data(iv.utf8) + Data([0])
            for count in [0, 1, 15, 16, 17, 32] {
                let plain = Data(repeating: 0x41, count: count)
                let original = legacy.encrypt(key, kind, iv, plain)
                let converted = try crypt(CCOperation(kCCEncrypt), key: keyBytes, iv: ivBytes, input: plain)
                XCTAssertEqual(original, converted)
                XCTAssertEqual(try crypt(CCOperation(kCCDecrypt), key: keyBytes, iv: ivBytes, input: original), plain)
                XCTAssertEqual(legacy.decrypt(key, kind, iv, converted), plain)
            }
        }
    }
}
