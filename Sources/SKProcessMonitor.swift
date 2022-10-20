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
    
    // MARK: Object Properties
    public static var label: String = "com.SystemKit.SKProcessMonitor"
    
    public var identifier: String = UUID().uuidString
    
    
}

// MARK: - Private Extension SKProcessMonitor
public extension SKProcessMonitor {
    
    final func test() {
        self.name = ""
        self.qualityOfService = .background
        self.queuePriority = .normal
    }
    
    final func monitorProcess(runLoop: CFRunLoop = CFRunLoopGetCurrent(), pid ident: UInt) {
        
        let kqueue: Int32 = kqueue()
        var processEvent = kevent(ident: ident, filter: Int16(EVFILT_PROC),
                                  flags: UInt16(EV_ADD | EV_RECEIPT), fflags: NOTE_EXIT,
                                  data: Int.zero, udata: nil)
        kevent(kqueue, &processEvent, 1, nil, 1, nil)
        
        var context: CFFileDescriptorContext = CFFileDescriptorContext()
        let descriptor: CFFileDescriptor = CFFileDescriptorCreate(nil, kqueue, true, { _,_,_ in print(1) }, &context)
        
        let source: CFRunLoopSource = CFFileDescriptorCreateRunLoopSource(nil, descriptor, CFIndex.zero)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), source, CFRunLoopMode.defaultMode)
        
        CFFileDescriptorEnableCallBacks(descriptor, kCFFileDescriptorReadCallBack)
    }
}

// MARK: - Public Extension SKProcessMonitor
public extension SKProcessMonitor {
    
    override func start() {
        
    }
    
    override func cancel() {
        
    }
}

#endif
