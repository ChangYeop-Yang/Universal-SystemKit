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

public class SKProcessMonitor: SKAsyncOperation {
    
    // MARK: - Struct
    private struct ProcessMonitorInfo {
        
        internal let pid: pid_t
        internal let runLoop: CFRunLoop
        internal let fflag: SKProcessMonitorFilterFlag
        internal let handler: CFFileDescriptorCallBack
        
        internal var descriptor: Optional<CFFileDescriptor> = nil
    }
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKProcessMonitor"
    public static var identifier: String = "A4031B25-241F-4457-9DF4-B711D022C4EA"
    
    private var info: ProcessMonitorInfo
    
    // MARK: - Initalize
    public init(name: Optional<String> = SKProcessMonitor.label,
                qualityOfService: QualityOfService = .default,
                queuePriority: Operation.QueuePriority = .normal,
                pid ident: pid_t,
                runLoop: CFRunLoop = CFRunLoopGetCurrent(),
                fflag: SKProcessMonitorFilterFlag,
                handler callback: @escaping CFFileDescriptorCallBack) {
        
        self.info = ProcessMonitorInfo(pid: ident, runLoop: runLoop, fflag: fflag, handler: callback)
        
        super.init()
        
        self.name = name
        self.queuePriority = queuePriority
        self.qualityOfService = qualityOfService
    }
}

// MARK: - Private Extension SKProcessMonitor
public extension SKProcessMonitor {
    
    final func enableMonitorProcess() {
        
        // 현재 작업이 취소가 된 상태인 경우에는 아래의 작업을 수행하지 않습니다.
        if self.isCancelled { return }
        
        let kqueue: Int32 = kqueue()
        var processEvent = kevent(ident: UInt(self.info.pid), filter: Int16(EVFILT_PROC),
                                  flags: UInt16(EV_ADD | EV_RECEIPT), fflags: self.info.fflag.define,
                                  data: Int.zero, udata: nil)
        kevent(kqueue, &processEvent, 1, nil, 1, nil)
        
        var context: CFFileDescriptorContext = CFFileDescriptorContext()
        self.info.descriptor = CFFileDescriptorCreate(nil, kqueue, true, self.info.handler, &context)
        
        let source: CFRunLoopSource = CFFileDescriptorCreateRunLoopSource(nil, self.info.descriptor, CFIndex.zero)
        CFRunLoopAddSource(self.info.runLoop, source, CFRunLoopMode.defaultMode)
        
        CFFileDescriptorEnableCallBacks(self.info.descriptor, kCFFileDescriptorReadCallBack)
    }
    
    final func disableMonitorProcess() {
        
        // 현재 작업이 활성화 상태인 경우에는 아래의 작업을 수행하지 않습니다.
        guard self.isCancelled else { return }
        
        CFRunLoopStop(self.info.runLoop)
        CFFileDescriptorDisableCallBacks(self.info.descriptor, kCFFileDescriptorReadCallBack)
    }
}

// MARK: - Public Extension SKProcessMonitor
public extension SKProcessMonitor {
    
    override func start() {
        super.start()
        
        enableMonitorProcess()
    }
    
    override func cancel() {
        super.cancel()
        
        disableMonitorProcess()
    }
}
#endif
