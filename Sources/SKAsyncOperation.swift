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

#if os(macOS) || os(iOS)
import Foundation

open class SKAsyncOperation: Operation {
    
    // MARK: - Enum
    public enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        
        // KVO notifications을 위한 keyPath설정
        fileprivate var keyPath: String {
            return String(format: "is%@", rawValue.capitalized)
        }
    }
    
    // MARK: - Object Properties
    public var state = State.ready {
        // 직접적으로 Operation 작업 상태를 관리하기 위한 Status Variable 생성
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

// MARK: - Open Extension AsyncOperation With Properties
extension SKAsyncOperation {
    
    open override var isReady: Bool { return super.isReady && self.state == State.ready }
    
    open override var isExecuting: Bool { return self.state == State.executing }
    
    open override var isFinished: Bool { return self.state == State.finished }
    
    open override var isAsynchronous: Bool { return true }
}

// MARK: - Open Extension AsyncOperation With Method
extension SKAsyncOperation {
    
    open override func start() {
    
        if self.isCancelled {
            self.state = State.finished
            return
        }
        
        self.main()
        
        NSLog("[SKAsyncOperation] Action, Operation Start: %@", self.state.keyPath)
        self.state = State.executing
    }
    
    open override func cancel() {
        super.cancel()
        
        NSLog("[SKAsyncOperation] Action, Operation Cancel: %@", self.state.keyPath)
        self.state = State.finished
    }
}
#endif
