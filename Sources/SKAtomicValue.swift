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

#if  os(iOS) || os(macOS) || os(Linux)
import Foundation

@propertyWrapper
public class SKAtomicValue<Value> {
    
    // MARK: - Object Properties
    private let dispatch = DispatchQueue(label: "com.SystemKit.SKAtomicValue")
    private var value: Value
    
    // MARK: - Computed Properties
    public var wrappedValue: Value {
        
        get {
            return self.dispatch.sync { return self.value }
        }
        
        set {
            self.dispatch.sync { self.value = newValue }
        }
    }
    
    // MARK: - Initalize
    public init(wrappedValue: Value) { self.value = wrappedValue }
}

// MARK: - Public Extension SKAtomicValue
public extension SKAtomicValue {
    
    typealias SKMutateHandler = (inout Value) -> Swift.Void
    final func mutate(_ mutating: SKMutateHandler) {
        
        return self.dispatch.sync { mutating(&self.value) }
    }
}
#endif
