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

import Foundation

public class SKSynchronizedArray<T>: NSObject {
    
    // MARK: - Typeaalise
    public typealias SynchronizedArrayType = Array<T>
    
    // MARK: - Object Properties
    private var array: SynchronizedArrayType = Array.init()
    private let implementQueue = DispatchQueue(label: "com.SystemKit.SKSynchronizedArray", attributes: .concurrent)
}

// MARK: - Private Extension SKSynchronizedArray
private extension SKSynchronizedArray {
    
    final func reader<U>(_ block: (SynchronizedArrayType) throws -> U) rethrows -> U {
        try self.implementQueue.sync { try block(self.array) }
    }

    typealias WriterBlock = (inout SynchronizedArrayType) -> Swift.Void
    final func writer(_ block: @escaping WriterBlock) {
        self.implementQueue.async(flags: .barrier) { block(&self.array) }
    }
}

// MARK: - Public Extension SKSynchronizedArray With Properties
public extension SKSynchronizedArray {
    
    subscript(atIndex: Int) -> T {
        get {
            self.reader { target in target[atIndex] }
        }
        
        set {
            self.writer { target in target[atIndex] = newValue }
        }
    }
    
    var count: Int {
        return self.reader { target in target.count }
    }
    
    var indices: Range<Int> {
        return self.reader { target in target.indices }
    }
    
    typealias EnumeratedSequenceType = EnumeratedSequence<SynchronizedArrayType>
    var enumerated: EnumeratedSequenceType {
        return self.reader { target in target.enumerated() }
    }
}

// MARK: - Public Extension SKSynchronizedArray With Method
public extension SKSynchronizedArray {
    
    final func append(newElement: T) {
        self.writer { target in target.append(newElement) }
    }
    
    final func append(contentsOf: T...) {
        for element in contentsOf { self.append(newElement: element) }
    }
    
    final func append(contentsOf: SynchronizedArrayType) {
        for element in contentsOf { self.append(newElement: element) }
    }
    
    final func remove(at atIndex: Int) {
        
        self.writer { target in
            guard target.count > atIndex else {
                NSLog("[ERROR] Occur, Could't Action Remove SynchronizedArray by Out Of Range")
                return
            }
            
            target.remove(at: atIndex)
        }
    }
    
    final func removeAll() {
        self.indices.forEach { index in self.remove(at: index) }
    }
}
