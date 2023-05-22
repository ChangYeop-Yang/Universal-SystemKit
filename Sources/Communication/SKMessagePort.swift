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
    
    private var messagePort: Optional<CFMessagePort>
    
    public var messagePortStatus: Optional<SKMessagePortStatus> {
        guard let targetPort = self.messagePort else { return nil }
        return SKMessagePortStatus(messagePort: targetPort)
    }
    
    // MARK: - Initalize
    public init(localPortName: String, _ callback: @escaping CFMessagePortCallBack) {
        logger.info("[SKMessagePort] init(localPortName: String, _ callback: @escaping CFMessagePortCallBack)")
        
        self.messagePort = SKMessagePort.createLocalMessagePort(portName: localPortName, callback)
    }
    
    public init(remotePortName: String) {
        logger.info("[SKMessagePort] init(remotePortName: String)")
        
        self.messagePort = SKMessagePort.createRemoteMessagePort(portName: remotePortName)
    }
}

// MARK: - Private Extension SKMessagePort
private extension SKMessagePort {
    
    /// Returns a local CFMessagePort object.
    static func createLocalMessagePort(portName: String,
                                       _ callback: @escaping CFMessagePortCallBack) -> Optional<CFMessagePort> {
        
        var context = CFMessagePortContext(version: CFIndex.zero,
                                           info: nil, retain: nil, release: nil, copyDescription: nil)
        
        var shouldFreeInfo: DarwinBoolean = false
        
        logger.info("[SKMessagePort] CFMessageLocalPort has been created.")
        
        // 동일한 프로세스 내에서 메시지를 보낼 때 사용하는 로컬 메시지 포트를 생성합니다.
        return CFMessagePortCreateLocal(nil, portName as CFString, callback, &context, &shouldFreeInfo)
    }
    
    /// Returns a CFMessagePort object connected to a remote port.
    static func createRemoteMessagePort(portName: String) -> Optional<CFMessagePort> {

        logger.info("[SKMessagePort] CFMessageRemotePort has been created.")

        // 다른 프로세스로 메시지를 보낼 때 사용하는 원격 메시지 포트를 생성합니다.
        return CFMessagePortCreateRemote(nil, portName as CFString)
    }
    
    final func getVaildMessagePort() -> Optional<CFMessagePort> {
        
        guard let targetPort: CFMessagePort = self.messagePort else {
            logger.error("[SKMessagePort] The CFMessagePort is invalid.")
            return nil
        }
        
        // Returns bool that indicates whether a CFMessagePort is valid and able to send or receive messages.
        guard CFMessagePortIsValid(targetPort) else {
            logger.error("[SKMessagePort] The CFMessagePort object is unable to perform normal operations.")
            return nil
        }
        
        return targetPort
    }
}

// MARK: - Public Extension SKMessagePort
public extension SKMessagePort {
    
    @discardableResult
    final func invalidate() -> Bool {
        
        logger.info("[SKMessagePort] Performing the invalidation operation on the CFMessagePort.")
        
        guard let targetPort: CFMessagePort = getVaildMessagePort() else { return false }
        
        CFMessagePortInvalidate(targetPort)
        
        return CFMessagePortIsValid(targetPort)
    }
    
    @discardableResult
    final func listen(queue: DispatchQueue) -> Bool {
        
        // CFMessagePort 유효성을 확인합니다.
        guard let targetPort: CFMessagePort = getVaildMessagePort() else { return false }
        
        // Schedules callbacks for the specified message port on the specified dispatch queue.
        CFMessagePortSetDispatchQueue(targetPort, queue)
        
        return true
    }
    
    @discardableResult
    final func listen(runLoop: CFRunLoop) -> Bool {
        
        // CFMessagePort 유효성을 확인합니다.
        guard let targetPort: CFMessagePort = getVaildMessagePort() else { return false }
    
        // Adds a CFRunLoopSource object to a run loop mode.
        CFRunLoopAddSource(runLoop,
                           CFMessagePortCreateRunLoopSource(nil, targetPort, CFIndex.zero),
                           CFRunLoopMode.commonModes)
        
        return true
    }
    
    @discardableResult
    final func send(messageID: Int32, message: Data,
                    sendTimeout: CFTimeInterval, recvTimeout: CFTimeInterval) -> SKMessagePortRequestError {
        
        // CFMessagePort 유효성을 확인합니다.
        guard let targetPort: CFMessagePort = getVaildMessagePort() else {
            return .failure(SKMessagePortSendRequestErrorCode.invalid)
        }
        
        // 전송하고자 하는 데이터가 비어있는 경우에는 전송하지 않습니다.
        if message.isEmpty {
            logger.error("[SKMessagePort] The data you want to send is empty.")
            return .failure(SKMessagePortSendRequestErrorCode.transportError)
        }
        
        let error = CFMessagePortSendRequest(targetPort, messageID, message as CFData, sendTimeout, recvTimeout, nil, nil)
        return SKMessagePortSendRequestErrorCode.getMessagePortRequestError(error)
    }
}
#endif
