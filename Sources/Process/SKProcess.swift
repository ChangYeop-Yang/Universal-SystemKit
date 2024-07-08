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
import Foundation

@available(macOS 10.12, *)
public class SKProcess: NSObject, SKClass {
    
    // MARK: - Typealias
    public typealias SKProcessErrorResult = (NSError, Process) -> Swift.Void
    public typealias SKProcessTerminationHandler = (Process) -> Swift.Void
    
    // MARK: - Object Properties
    public static let shared: SKProcess = SKProcess()
    public static let label: String = "com.SystemKit.SKProcess"
    public static let identifier: String = "B275BF0C-3E1B-4897-B6CB-CA3DC7FFD3EB"
    
    // MARK: - Initalize
    private override init() { super.init() }
}

// MARK: - Private Extension SKProcess
@available(macOS 10.12, *)
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
    
    final func closePipe(_ pipe: Optional<Pipe>) {
        
        // If the PIPE is not used, the close operation is not performed
        guard let target = pipe else { return }
        
        // The writing file handle close
        try? target.fileHandleForWriting.close()
        
        // The reading file handle close
        try? target.fileHandleForReading.close()
    }
}

// MARK: - Public Extension SKProcess
@available(macOS 10.12, *)
public extension SKProcess {
    
    @discardableResult
    final func run(launchPath: String,
                   arguments: Array<String>,
                   standardInput: Optional<Pipe> = nil,
                   standardOutput: Optional<Pipe> = nil,
                   standardError: Optional<Pipe> = nil,
                   waitUntilExit: Bool = false,
                   qualityOfService: QualityOfService = .default,
                   terminationHandler: Optional<SKProcessTerminationHandler> = nil,
                   errorCompletionHandler: Optional<SKProcessErrorResult> = nil) -> Int32 {
        
        let process = Process()
        process.launchPath = launchPath
        process.arguments = arguments
        process.terminationHandler = terminationHandler
        process.standardInput = standardInput
        process.standardOutput = standardOutput
        process.standardError = standardError
        process.qualityOfService = qualityOfService
        
        do {
            try launch(process: process)
            
            if waitUntilExit { process.waitUntilExit() }
            
            // Closing the PIPE used in the operation
            [standardInput, standardOutput, standardError].forEach(closePipe)
            
        } catch let error as NSError {
            errorCompletionHandler?(error, process)
            return EOF
        }
        
        return process.processIdentifier
    }
}
#endif
