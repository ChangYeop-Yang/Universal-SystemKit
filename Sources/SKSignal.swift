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
import Dispatch
import Foundation

public class SKSignal: SKAsyncOperation, SKClass {
    
    // MARK: - Typealias
    public typealias SKSignalHandler = @convention(c) (Int32) -> Swift.Void
    private typealias SKSignalResult = (signal: Int32, handler: SKSignalHandler)
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKSignal"
    
    private let result: SKSignalResult
    private var source: Optional<DispatchSourceSignal> = nil
    public var identifier: String = UUID().uuidString
    
    // MARK: - Initalize
    public init(signal number: Int32, handler: @escaping SKSignalHandler) {
        self.result = SKSignalResult(number, handler)
    }
}

// MARK: - Private Extension SKSignal
private extension SKSignal {
    
    final func observeSignal(signal number: Int32, handler: @escaping SKSignalHandler) {
        
        // 현재 작업이 취소 상태인 경우에는 아래의 등록 작업을 하지 않습니다.
        if self.isCancelled { return }
        
        // SIGNAL 등록 작업을 수행하기 전에 기존의 SIGNAL 이벤트를 거부 작업을 수행합니다.
        signal(number, SIG_IGN)
        
        self.source = DispatchSource.makeSignalSource(signal: number)
        self.source?.setEventHandler { handler(number) }
        self.source?.resume()
    }
    
    final func removeObserveSignal() {
        
        // 현재 작업이 취소 상태가 아닌 경우에는 아래의 취소작업을 하지 않습니다.
        guard self.isCancelled else { return }
        
        NSLog("[%@][%@] Action, Remove Signal Observe: %@", SKSignal.label, self.identifier, self.result.signal)
        
        self.source?.cancel()
        self.source = nil
    }
}

// MARK: - Public Extension SKSignal
public extension SKSignal {
    
    override func start() {
        
        // Signal Handler 등록 작업을 수행합니다.
        observeSignal(signal: self.result.signal, handler: self.result.handler)
    }
    
    override func cancel() {
        
        // Signal handler 등록 해제 작업을 수행합니다.
        removeObserveSignal()
    }
}
#endif
