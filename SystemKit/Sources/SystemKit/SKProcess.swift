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

import Logging
import Foundation

public class SKProcess: NSObject {
    
    // MARK: - Typealias
    public typealias SKProcessErrorResult = (NSError) -> Swift.Void
    
    // MARK: - Object Properties
    public static let shared: SKProcess = SKProcess()
    
    // MARK: - Initalize
    private override init() { super.init() }
}

// MARK: - Private Extension SKProcess
private extension SKProcess {
    
    final func launch(process: Process) throws {
        
        // macOS 10.13 미만의 운영체제에서는 launch() 함수를 통하여 실행합니다.
        guard #available(macOS 10.13, *) else {
            process.launch()
            return
        }
        
        // macOS 10.13 이상의 운영체제에서는 run() 함수를 통하여 실행합니다.
        try process.run()
    }
}

// MARK: - Public Extension SKProcess
public extension SKProcess {
    
    @discardableResult
    final func run(launchPath: String, arguments: [String],
                   standardInput: Any? = nil, standardOutput: Any? = nil, standardError: Any? = nil,
                   waitUntilExit: Bool,
                   errorCompletionHandler: SKProcessErrorResult? = nil) -> Int32 {
        
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        process.standardInput = standardInput
        process.standardOutput = standardOutput
        process.standardError = standardError
        
        do {
            try launch(process: process)

            if waitUntilExit {
                process.waitUntilExit()
            }
        } catch let error as NSError {
            errorCompletionHandler?(error)
            return EOF
        }
        
        return process.processIdentifier
    }
}

