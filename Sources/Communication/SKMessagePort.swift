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

public class SKMessagePort: SKClass {
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKMessagePort"
    public static var identifier: String = "368027F0-C77F-4F81-B352-F92B7B0370DB"
    
    private let portName: String
    private var callback: Optional<CFMessagePortCallBack>
    
    // MARK: - Initalize
    public init(localPortName: String, _ callback: @escaping CFMessagePortCallBack) {
        logger.info("[SKMessagePort] init(localPortName: String, _ callback: @escaping CFMessagePortCallBack)")
        
        self.callback = callback
        self.portName = localPortName
    }
    
    public init(remotePortName: String) {
        logger.info("[SKMessagePort] init(remotePortName: String)")
        
        self.callback = nil
        self.portName = remotePortName
    }
}

// MARK: - Private Extension SKMessagePort
private extension SKMessagePort {
    
    /// Returns a local CFMessagePort object.
    final func createLocalMessagePort() -> Optional<CFMessagePort> {
        
        var context = CFMessagePortContext(version: CFIndex.zero,
                                           info: nil, retain: nil, release: nil, copyDescription: nil)
        
        var shouldFreeInfo: DarwinBoolean = false
        
        return CFMessagePortCreateLocal(nil, self.portName as CFString, self.callback, &context, &shouldFreeInfo)
    }
    
    /// Returns a CFMessagePort object connected to a remote port.
    final func createRemoteMessagePort() -> Optional<CFMessagePort> {
        return CFMessagePortCreateRemote(nil, self.portName as CFString)
    }
    
    final func addRunLoopSource(runLoop: CFRunLoop = CFRunLoopGetCurrent()) -> Bool {
        
        guard let localPort: CFMessagePort = createLocalMessagePort() else {
            logger.error("[SKMessagePort]")
            return false
        }
        
        // Returns bool that indicates whether a CFMessagePort is valid and able to send or receive messages.
        guard CFMessagePortIsValid(localPort) else {
            logger.error("[SKMessagePort]")
            return false
        }
        
        let source = CFMessagePortCreateRunLoopSource(nil, localPort, CFIndex.zero)
        CFRunLoopAddSource(runLoop, source, CFRunLoopMode.commonModes)
        
        //CFRunLoopStop(runLoop)
        return true
    }
}

// MARK: - Public Extension SKMessagePort
public extension SKMessagePort {
    
    @discardableResult
    final func listen(runLoop: CFRunLoop = CFRunLoopGetCurrent()) -> Bool {
        
        return true
    }
    
    @discardableResult
    final func send(messageID: Int32, message: Data,
                    sendTimeout: CFTimeInterval, recvTimeout: CFTimeInterval) -> MessagePortRequestError {
        
        // 데이터를 전송하기 위한 대상의 CFMessageRemotePort를 생성합니다
        guard let remotePort: CFMessagePort = createRemoteMessagePort() else {
            logger.error("[SKMessagePort]")
            return .failure(SKMessagePortSendRequestErrorCode.invalid)
        }
        
        // CFMessagePortCreateRemote를 통해서 생성 된 CFMessagePort 유효한지 확인합니다.
        guard CFMessagePortIsValid(remotePort) else {
            logger.error("[SKMessagePort]")
            return .failure(SKMessagePortSendRequestErrorCode.BecameInvalidError)
        }
        
        // 전송하고자 하는 데이터가 비어있는 경우에는 전송하지 않습니다.
        if message.isEmpty {
            logger.error("[SKMessagePort]")
            return .failure(SKMessagePortSendRequestErrorCode.transportError)
        }
        
        let error = CFMessagePortSendRequest(remotePort, messageID, message as CFData, sendTimeout, recvTimeout, nil, nil)
        return SKMessagePortSendRequestErrorCode.getMessagePortRequestError(error)
    }
}
#endif
