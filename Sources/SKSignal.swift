/*
 * Copyright (c) 2022 ChangYeop-Yang. All rights reserved.
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
    private typealias SKSignalValue = (signal: Int32, handler: SKSignalHandler)
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKSignal"
    
    private let target: SKSignalValue
    private var source: Optional<DispatchSourceSignal> = nil
    public var identifier: String = UUID().uuidString
    
    // MARK: - Initalize
    public init(signal number: Int32, handler: @escaping SKSignalHandler) {
        self.target = SKSignalValue(number, handler)
    }
}

// MARK: - Private Extension SKSignal
private extension SKSignal {
    
    final func observeSignal(signal number: Int32, handler: @escaping SKSignalHandler) {
        
        signal(number, SIG_IGN)
        
        self.source = DispatchSource.makeSignalSource(signal: number)
        
        self.source?.setEventHandler { handler(number) }
        
        self.source?.resume()
    }
    
    final func removeObserveSignal() {
        
        guard self.isCancelled else { return }
        
        self.source?.cancel()
        self.source = nil
    }
}

// MARK: - Public Extension SKSignal
public extension SKSignal {
    
    override func start() {
        observeSignal(signal: self.target.signal, handler: self.target.handler)
    }
    
    override func cancel() {
        removeObserveSignal()
    }
}
#endif
