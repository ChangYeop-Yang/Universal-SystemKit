/*
 * Copyright (c) 2024 Universal-SystemKit. All rights reserved.
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

import Dispatch
import Foundation

@objc public class SKDispatchFileMonitor: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static let label: String = "com.SystemKit.SKDispatchFileMonitor"
    public static let identifier: String = "A2BC9AF4-45B0-4C49-8D6B-1B0BAB8AC3FA"
    public static let name = Notification.Name(SKDispatchFileMonitor.label)
    
    private let source: DispatchSourceFileSystemObject
    private var handler: Optional<SKFileEventHandler>
    
    // MARK: - Initalize
    public init?(filePath: String, eventMask: DispatchSource.FileSystemEvent, handler: Optional<SKFileEventHandler> = nil) {
        
        // Creating a FileHandle
        guard let fileDescriptor = SKDispatchFileMonitor.makeFileDescriptor(filePath: filePath) else { return nil }
        
        // Creating a DispatchSourceFileSystemObject
        guard let source = SKDispatchFileMonitor.makeFileSystemObjectSource(fileDescriptor: fileDescriptor,
                                                                            eventMask: eventMask) else { return nil }
        
        self.source = source
        self.handler = handler
    }
    
    // MARK: - Deinitalize
    deinit { stop() }
}

// MARK: - Private Extension SKDispatchFileMonitor
private extension SKDispatchFileMonitor {
    
    static func makeFileDescriptor(filePath: String) -> Optional<Int32> {
        
        // Creating a FileDescriptor
        let fileDescriptor = open(filePath, O_EVTONLY | F_NOCACHE)
        
        // Failed to create FileDescriptor
        if fileDescriptor < 0 { return nil }
        
        return fileDescriptor
    }
    
    static func makeFileSystemObjectSource(fileDescriptor: Int32, 
                                           eventMask: DispatchSource.FileSystemEvent) -> Optional<DispatchSourceFileSystemObject> {

        let queue = DispatchQueue(label: SKDispatchFileMonitor.label, qos: .background, attributes: .concurrent)
        
        do { return DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: eventMask, queue: queue) }
        catch let error as NSError {
            logger.error("[SKDispatchFileMonitor] Failed to create file-system events: \(error.description)")
            return nil
        }
    }
    
    final func occurEventHandler() {
        
        logger.info("[SKDispatchFileMonitor] Setting up an EventHandler for FileSystem")
        
        self.handler?(self.source.data)
        
        NotificationCenter.default.post(name: SKDispatchFileMonitor.name, object: self.source.data)
    }
    
    final func occurCancelHandler() {
        
        logger.info("[SKDispatchFileMonitor] Setting up an CancelEventHandler for FileSystem")
        
        // Cleaning up objects used in FileSystemEvent
        self.handler = nil
        close(self.source.handle)
        
        NotificationCenter.default.post(name: SKDispatchFileMonitor.name, object: nil)
    }
}

// MARK: - Public Extension SKDispatchFileMonitor
public extension SKDispatchFileMonitor {
    
    final func start() {
        
        // Setting up an EventHandler for DispatchSourceFileSystem
        self.source.setEventHandler { [unowned self] in self.occurEventHandler() }
        
        // Setting up an CancelEventHandler for DispatchSourceFileSystem
        self.source.setCancelHandler { [unowned self] in self.occurCancelHandler() }
        
        // Resumes the DispatchSourceFileSystem
        self.source.resume()
    }
    
    final func stop() {
        
        logger.info("[SKDispatchFileMonitor] Stopping FileSystemEvent monitoring")
        
        // cancel the DispatchSourceFileSystem
        self.source.cancel()
    }
}
