/*
 * Copyright (c) 2023 Universal-SystemKit. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#if os(iOS) || os(macOS)
import Foundation
import CoreFoundation

// MARK: - Typealias
public typealias SKMessageLocalPort = (messagePort: CFMessagePort, instance: UnsafeMutablePointer<AnyObject>)
public typealias SKMessagePortRequestResult = Result<Int32, Error>

// MARK: - Enum
public enum SKMessagePortSendRequestErrorCode: Error {
    
    // https://developer.apple.com/documentation/corefoundation/cfmessageport/1561514-cfmessageportsendrequest_error_c
    
    /// The message was successfully sent and, if a reply was expected, a reply was received.
    case success
    
    /// The message could not be sent before the send timeout.
    case timeoutSend
    
    /// No reply was received before the receive timeout.
    case timeoutReceive
    
    /// The message could not be sent because the message port is invalid.
    case invalid
    
    /// An error occurred trying to send the message.
    case transportError
    
    /// The message port was invalidated.
    case BecameInvalidError
    
    // MARK: Enum Computed Properties
    public var errorCode: Int32 {
        
        // Error codes for CFMessagePortSendRequest.
        switch self {
        case .success:
            return kCFMessagePortSuccess
        case .timeoutSend:
            return kCFMessagePortSendTimeout
        case .timeoutReceive:
            return kCFMessagePortReceiveTimeout
        case .invalid:
            return kCFMessagePortIsInvalid
        case .transportError:
            return kCFMessagePortTransportError
        case .BecameInvalidError:
            return kCFMessagePortBecameInvalidError
        }
    }
    
    // MARK: Enum Method
    public static func getMessagePortRequestError(_ errorCode: Int32) -> SKMessagePortRequestResult {
        
        switch errorCode {
        case kCFMessagePortSuccess:
            return .success(SKMessagePortSendRequestErrorCode.success.errorCode)
        case kCFMessagePortSendTimeout:
            return .failure(SKMessagePortSendRequestErrorCode.timeoutSend)
        case kCFMessagePortReceiveTimeout:
            return .failure(SKMessagePortSendRequestErrorCode.timeoutReceive)
        case kCFMessagePortIsInvalid:
            return .failure(SKMessagePortSendRequestErrorCode.invalid)
        case kCFMessagePortTransportError:
            return .failure(SKMessagePortSendRequestErrorCode.transportError)
        case kCFMessagePortBecameInvalidError:
            return .failure(SKMessagePortSendRequestErrorCode.BecameInvalidError)
        default:
            fatalError("The value of CFMessagePortSendRequest Error Codes is invalid.")
        }
    }
}
#endif
