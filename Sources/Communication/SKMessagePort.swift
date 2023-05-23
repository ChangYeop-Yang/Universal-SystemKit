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
    
    /// A reference to a message port object.
    private var messagePort: Optional<CFMessagePort>
    
    // MARK: - Computed Properties
    public var messagePortStatus: Optional<SKMessagePortStatus> {
        return SKMessagePortStatus(messagePort: self.messagePort)
    }
    
    // MARK: - Initalize
    public init(localPortName: String,
                _ callback: @escaping CFMessagePortCallBack,
                _ callout: @escaping CFMessagePortInvalidationCallBack) {
        
        self.messagePort = SKMessagePort.createLocalMessagePort(portName: localPortName, callback, callout)
    }
    
    public init(remotePortName: String,
                _ callout: @escaping CFMessagePortInvalidationCallBack) {
        
        self.messagePort = SKMessagePort.createRemoteMessagePort(portName: remotePortName, callout)
    }
}

// MARK: - Private Extension SKMessagePort
private extension SKMessagePort {
    
    /// Returns a local CFMessagePort object.
    static func createLocalMessagePort(portName: String,
                                       _ callback: @escaping CFMessagePortCallBack,
                                       _ callout: @escaping CFMessagePortInvalidationCallBack) -> Optional<CFMessagePort> {
        
        NSLog("[SKMessagePort] CFMessageLocalPort has been created.")
        
        var context = CFMessagePortContext(version: CFIndex.zero,
                                           info: nil, retain: nil, release: nil, copyDescription: nil)
        
        var shouldFreeInfo: DarwinBoolean = false
        
        // 동일한 프로세스 내에서 메시지를 보낼 때 사용하는 로컬 메시지 포트를 생성합니다.
        guard let result = CFMessagePortCreateLocal(nil, portName as CFString,
                                                    callback, &context, &shouldFreeInfo) else {
            NSLog("[SKMessagePort] Failed to create a CFMessageLocalPort object.")
            return nil
        }
        
        // Sets the callback function invoked when a CFMessagePort object is invalidated.
        CFMessagePortSetInvalidationCallBack(result, callout)
        
        return result
    }
    
    /// Returns a CFMessagePort object connected to a remote port.
    static func createRemoteMessagePort(portName: String,
                                        _ callout: @escaping CFMessagePortInvalidationCallBack) -> Optional<CFMessagePort> {

        NSLog("[SKMessagePort] CFMessageRemotePort has been created.")

        // 다른 프로세스로 메시지를 보낼 때 사용하는 원격 메시지 포트를 생성합니다.
        guard let result = CFMessagePortCreateRemote(nil, portName as CFString) else {
            NSLog("[SKMessagePort] Failed to create a CFMessageRemotePort object.")
            return nil
        }

        // Sets the callback function invoked when a CFMessagePort object is invalidated.
        CFMessagePortSetInvalidationCallBack(result, callout)

        return result
    }
    
    final func getVaildMessagePort() -> Optional<CFMessagePort> {
        
        guard let targetPort: CFMessagePort = self.messagePort else {
            NSLog("[SKMessagePort] The CFMessagePort is invalid.")
            return nil
        }
        
        // Returns bool that indicates whether a CFMessagePort is valid and able to send or receive messages.
        guard CFMessagePortIsValid(targetPort) else {
            NSLog("[SKMessagePort] The CFMessagePort object is unable to perform normal operations.")
            return nil
        }
        
        return targetPort
    }
}

// MARK: - Public Extension SKMessagePort
public extension SKMessagePort {
    
    @discardableResult
    final func invalidate() -> Bool {
        
        NSLog("[SKMessagePort] Performing invalidate on the CFMessagePort.")
        
        // CFMessagePort 유효성을 확인하여 CFMessagePort 객체를 가져옵니다.
        guard let targetPort = getVaildMessagePort() else { return false }
        
        // Invalidates a CFMessagePort object, stopping it from receiving or sending any more messages.
        CFMessagePortInvalidate(targetPort)
        
        // 정상적으로 CFMessagePort 객체가 소멸이 되었는 경우에는 false, 소멸되지 않은 경우에는 true를 반환합니다.
        return CFMessagePortIsValid(targetPort)
    }
    
    final func listen(queue: DispatchQueue) {
        
        NSLog("[SKMessagePort] Performing the listen on the CFMessagePort by DispatchQueue.")
 
        // CFMessagePort 유효성을 확인하여 CFMessagePort 객체를 가져옵니다.
        guard let targetPort = getVaildMessagePort() else { return }

        // Schedules callbacks for the specified message port on the specified dispatch queue.
        CFMessagePortSetDispatchQueue(targetPort, queue)
    }
    
    final func listen(runLoop: RunLoop) {
        
        NSLog("[SKMessagePort] Performing the listen on the CFMessagePort by CFRunLoop.")

        // CFMessagePort 유효성을 확인하여 CFMessagePort 객체를 가져옵니다.
        guard let targetPort = getVaildMessagePort() else { return }

        // Adds a CFRunLoopSource object to a run loop mode.
        CFRunLoopAddSource(runLoop.getCFRunLoop(),
                           CFMessagePortCreateRunLoopSource(nil, targetPort, CFIndex.zero),
                           CFRunLoopMode.commonModes)
    }
    
    @discardableResult
    final func send(messageID: Int32, message: Data,
                    sendTimeout: CFTimeInterval, recvTimeout: CFTimeInterval) -> SKMessagePortRequestError {
        
        // CFMessagePort 유효성을 확인하여 CFMessagePort 객체를 가져옵니다.
        guard let targetPort = getVaildMessagePort() else {
            return .failure(SKMessagePortSendRequestErrorCode.invalid)
        }
        
        // 전송하고자 하는 데이터가 비어있는 경우에는 전송하지 않습니다.
        if message.isEmpty {
            return .failure(SKMessagePortSendRequestErrorCode.transportError)
        }
        
        // Sends a message to a remote CFMessagePort object.
        let error = CFMessagePortSendRequest(targetPort, messageID, message as CFData, sendTimeout, recvTimeout, nil, nil)
        return SKMessagePortSendRequestErrorCode.getMessagePortRequestError(error)
    }
}
#endif
