/*
 * Copyright (c) 2022 Universal-SystemKit. All rights reserved.
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

#if os(macOS)
import Darwin
import Foundation
import CoreFoundation

public class SKProcessMonitor: SKAsyncOperation, SKOperation {
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKProcessMonitor"
    
    private var pid: pid_t = pid_t.zero
    private var handler: Optional<CFFileDescriptorCallBack> = nil
    public var identifier: String = UUID().uuidString
    
    // MARK: - Initalize
    public override init() { super.init() }
    
    public required init(name: Optional<String>,
                         qualityOfService: QualityOfService, queuePriority: Operation.QueuePriority) {
        super.init()
        
        self.name = name
        self.queuePriority = queuePriority
        self.qualityOfService = qualityOfService
    }
    
    public convenience init(name: Optional<String> = SKProcessMonitor.label,
                            qualityOfService: QualityOfService = .default,
                            queuePriority: Operation.QueuePriority = .normal,
                            pid: pid_t,
                            handler callback: @escaping CFFileDescriptorCallBack) {
        self.init(name: name, qualityOfService: qualityOfService, queuePriority: queuePriority)
        
        self.pid = pid
        self.handler = callback
    }
}

// MARK: - Private Extension SKProcessMonitor
public extension SKProcessMonitor {
    
    final func monitorProcess(runLoop: CFRunLoop = CFRunLoopGetCurrent(), pid ident: UInt) {
        
        // CFFileDescriptorCallBack Optional 경우에는 함수를 종료합니다.
        if self.handler == nil {
            NSLog("[%@][%@] Error, Empty CFFileDescriptorCallBack Parameter", SKProcessMonitor.label, self.identifier)
            return
        }
        
        let kqueue: Int32 = kqueue()
        var processEvent = kevent(ident: ident, filter: Int16(EVFILT_PROC),
                                  flags: UInt16(EV_ADD | EV_RECEIPT), fflags: NOTE_EXIT,
                                  data: Int.zero, udata: nil)
        kevent(kqueue, &processEvent, 1, nil, 1, nil)
        
        var context: CFFileDescriptorContext = CFFileDescriptorContext()
        let descriptor: CFFileDescriptor = CFFileDescriptorCreate(nil, kqueue, true, self.handler, &context)
        
        let source: CFRunLoopSource = CFFileDescriptorCreateRunLoopSource(nil, descriptor, CFIndex.zero)
        CFRunLoopAddSource(runLoop, source, CFRunLoopMode.defaultMode)
        
        CFFileDescriptorEnableCallBacks(descriptor, kCFFileDescriptorReadCallBack)
    }
}

// MARK: - Public Extension SKProcessMonitor
public extension SKProcessMonitor {
    
    override func start() {
        
        let ident: UInt = UInt(self.pid)
        monitorProcess(pid: ident)
    }
}
#endif
