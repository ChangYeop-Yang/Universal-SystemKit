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

#if os(iOS) || os(macOS) || os(Linux)
import Foundation
import CoreFoundation

public class SKMessagePort: SKClass {
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKMessagePort"
    public static var identifier: String = "368027F0-C77F-4F81-B352-F92B7B0370DB"
    
    private var portName: CFString
    private var portAttribute: Optional<SKMessageLocalPort>
    private var invalidateCallBack: CFMessagePortInvalidationCallBack
    
    // MARK: - Initalize
    public init(portName: String, _ invalidateCallBack: @escaping CFMessagePortInvalidationCallBack) {
        self.portName = portName as CFString
        self.portAttribute = nil
        self.invalidateCallBack = invalidateCallBack
    }
}

// MARK: - Private Extension SKMessagePort
private extension SKMessagePort {
    
    final func createMutablePointer<T: AnyObject>(instance: T) -> UnsafeMutablePointer<T> {
        
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        
        pointer.initialize(to: instance)
        
        return pointer
    }
    
    /// Returns a local CFMessagePort object.
    final func createLocalMessagePort(instance: AnyObject,
                                      _ callback: @escaping CFMessagePortCallBack) -> Optional<SKMessageLocalPort> {

        let pointer = createMutablePointer(instance: instance)

        var context = CFMessagePortContext(version: CFIndex.zero, info: pointer,
                                           retain: nil, release: nil, copyDescription: nil)

        var shouldFreeInfo: DarwinBoolean = false

        // 동일한 프로세스 내에서 메시지를 보낼 때 사용하는 로컬 메시지 포트를 생성합니다.
        guard let localPort = CFMessagePortCreateLocal(kCFAllocatorDefault,
                                                       self.portName, callback, &context, &shouldFreeInfo) else {
            logger.error("[SKMessagePort] Failed to create a CFMessageLocalPort object.")
            return nil
        }

        // Sets the callback function invoked when a CFMessagePort object is invalidated.
        CFMessagePortSetInvalidationCallBack(localPort, self.invalidateCallBack)
        
        // The flag is set to true on failure or if a local port named name already exists, false otherwise.
        switch shouldFreeInfo.boolValue {
        case true:
            logger.error("[SKMessagePort] Could not create CFMessageLocalPort as it already exists.")
            return nil

        case false:
            logger.info("[SKMessagePort] CFMessageLocalPort has been created.")
            return SKMessageLocalPort(localPort, pointer)
        }
    }
    
    /// Returns a CFMessagePort object connected to a remote port.
    final func createRemoteMessagePort() -> Optional<CFMessagePort> {

        // 다른 프로세스로 메시지를 보낼 때 사용하는 원격 메시지 포트를 생성합니다.
        guard let remotePort = CFMessagePortCreateRemote(kCFAllocatorDefault, self.portName) else {
            logger.error("[SKMessagePort] Failed to create a CFMessageRemotePort object.")
            return nil
        }

        // Sets the callback function invoked when a CFMessagePort object is invalidated.
        CFMessagePortSetInvalidationCallBack(remotePort, self.invalidateCallBack)
        
        logger.info("[SKMessagePort] CFMessageRemotePort has been created.")

        return remotePort
    }
    
    final func invalidate(_ messagePort: CFMessagePort) {
        
        logger.info("[SKMessagePort] Performing invalidate on the CFMessagePort.")
        
        // Invalidates a CFMessagePort object, stopping it from receiving or sending any more messages.
        CFMessagePortInvalidate(messagePort)
    }
}

// MARK: - Public Extension SKMessagePort
public extension SKMessagePort {
    
    final func invalidate() {

        // CFMessagePort 초기화 작업 대상 존재 여부를 확인합니다.
        guard let attribuate = self.portAttribute else {
            logger.error("[SKMessagePort] There are no targets to perform the invalidation.")
            return
        }

        // Deallocates the memory block previously allocated at this pointer.
        attribuate.instance.deallocate()

        // Invalidates a CFMessagePort object, stopping it from receiving or sending any more messages.
        invalidate(attribuate.messagePort)
    }
    
    @discardableResult
    final func listen(dispatch: DispatchQueue,
                      info: AnyObject, _ callback: @escaping CFMessagePortCallBack) -> Bool {
 
        guard let attribute = createLocalMessagePort(instance: info, callback) else { return false }
        
        // CFMessagePort가 활성화 상태가 유지되도록 전역 변수에 저장합니다.
        self.portAttribute = attribute
        
        // Schedules callbacks for the specified message port on the specified dispatch queue.
        CFMessagePortSetDispatchQueue(attribute.messagePort, dispatch)
        
        logger.info("[SKMessagePort] Performing the listen on the CFMessagePort by DispatchQueue.")
        
        return CFMessagePortIsValid(attribute.messagePort)
    }
    
    @discardableResult
    final func send(messageID: Int32, message: Data,
                    sendTimeout: CFTimeInterval = CFTimeInterval.zero,
                    recvTimeout: CFTimeInterval = CFTimeInterval.zero) -> SKMessagePortRequestResult {

        // 데이터 전송을 위하여 CFMessageRemotePort를 생성합니다.
        guard let remotePort = createRemoteMessagePort() else {
            return .failure(SKMessagePortSendRequestErrorCode.invalid)
        }

        // 데이터 전송 후 CFMessageRemotePort 소멸작업을 수행합니다.
        defer { invalidate(remotePort) }

        // 전송하고자 하는 데이터가 비어있는 경우에는 전송하지 않습니다.
        if message.isEmpty {
            logger.error("[SKMessagePort] The data to be transferred is empty.")
            return .failure(SKMessagePortSendRequestErrorCode.transportError)
        }

        // Sends a message to a remote CFMessagePort object.
        let error = CFMessagePortSendRequest(remotePort, messageID, message as CFData, sendTimeout, recvTimeout, nil, nil)
        
        switch SKMessagePortSendRequestErrorCode.getMessagePortRequestError(error) {
        case .success:
            logger.info("[SKMessagePort] \(message.count) Bytes of data has been transferred.")
            return .success(kCFMessagePortSuccess)
            
        case .failure(let error):
            logger.error("[SKMessagePort] Error occur: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}
#endif
