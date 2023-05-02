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

// swiftlint:disable all
#if os(iOS) || os(macOS)
import Darwin
import Foundation

/**
    - Date: `2023.05.01.`
    - Version: `1.0.0`
    - Authors: `ChangYeop-Yang`
 */
public class SKFileLock: SKClass {
    
    // MARK: - Enum
    public enum FileLockMode: Int {
        case read
        case write
        case update
    }
    
    // MARK: - Object Properties
    public static var label = "com.SystemKit.SKFileLock"
    public static var identifier = "7777529A-98A3-4E43-A3AA-AAFBE437BC3F"
    
    private let filePath: String
    private let fileHandle: Optional<FileHandle>
    
    // MARK: - Initalize
    public init(filePath: String, _ mode: FileLockMode) {
        logger.info("[SKFileLock] init(filePath: String, mode: FileLockMode)")
        
        self.filePath = filePath
        self.fileHandle = SKFileLock.createFileHandle(filePath: filePath, mode)
    }
    
    public init(fileDescriptor: Int32) {
        logger.info("[SKFileLock] init(fileDescriptor: Int32)")

        self.filePath = SKFileLock.getFilePath(fileDescriptor: fileDescriptor) ?? String.init()
        self.fileHandle = FileHandle(fileDescriptor: fileDescriptor)
    }
}

// MARK: - Private Extension SKFileLock
private extension SKFileLock {
    
    static func createFileHandle(filePath: String, _ mode: FileLockMode) -> Optional<FileHandle> {
        
        switch mode {
        case .read:
            return FileHandle(forReadingAtPath: filePath)
        case .write:
            return FileHandle(forWritingAtPath: filePath)
        case .update:
            return FileHandle(forUpdatingAtPath: filePath)
        }
    }
    
    static func getFilePath(fileDescriptor: Int32) -> Optional<String> {
        
        let maxPathSize = Int(PATH_MAX)
        var filePath = [CChar](repeating: CChar.zero, count: maxPathSize)

        guard fcntl(fileDescriptor, F_GETPATH, &filePath) == Int32.zero else { return nil }
        
        return String(cString: filePath)
    }
}

// MARK: - Public Extension SKFileLock
public extension SKFileLock {
    
    /**
        파일에 대하여 `파일 잠금 (File Locking)`을(를) 수행합니다.

        - Version: `1.0.0`
        - Returns: `Bool`
    */
    @discardableResult
    final func lock() -> Bool {
        
        logger.info("[SKFileLock] Perform a file lock on the file located at the \(self.filePath) path.")
        
        guard let fileDescriptor = self.fileHandle?.fileDescriptor else { return false }
        
        // 파일 잠금 (File Locking) 작업 수행 여부를 확인합니다.
        guard flock(fileDescriptor, LOCK_EX | LOCK_NB) == Int32.zero else { return false }
        
        return true
    }
    
    /**
        파일에 대하여 `파일 잠금 해제 (File UnLocking)`을(를) 수행합니다.

        - Version: `1.0.0`
        - Returns: `Bool`
    */
    @discardableResult
    final func unlock() -> Bool {
        
        logger.info("[SKFileLock] Perform a file unlock on the file located at the \(self.filePath) path.")
        
        guard let fileDescriptor = self.fileHandle?.fileDescriptor else { return false }
        
        // 파일 잠금 해제 (File UnLocking) 작업 수행 여부를 확인합니다.
        guard flock(fileDescriptor, LOCK_UN) == Int32.zero else { return false }
        
        return true
    }
}
#endif
