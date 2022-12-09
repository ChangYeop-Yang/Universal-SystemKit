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

// swiftlint:disable all
#if os(iOS) || os(macOS)
import Network
import Foundation

@available(iOS 12.0, macOS 10.14, *)
public class SKNetworkMonitor: SKClass {
    
    // MARK: - Typealias
    public typealias SKNetworkStatus = (isConnected: Bool, image: SKNetworkStatusSymbols)
    public typealias SKNetworkStatusUpdateHandler = (SKNetworkMonitorStatus) -> Swift.Void
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKNetworkMonitor"
    public static var identifier: String = "5C6F96D5-C21E-4A48-9AED-15794E19A4E9"

    private let implementQueue: DispatchQueue = DispatchQueue(label: SKNetworkMonitor.label, attributes: .concurrent)
    private let monitor: NWPathMonitor = NWPathMonitor()
    private let pathUpdateHandler: SKNetworkStatusUpdateHandler
    
    // MARK: - Initalize
    public init(pathUpdateHandler: @escaping SKNetworkStatusUpdateHandler) {
        self.pathUpdateHandler = pathUpdateHandler
    }
}

// MARK: - Public Extension SKNetworkMonitor
@available(iOS 12.0, macOS 10.14, *)
public extension SKNetworkMonitor {
    
    final func startMonitor() {
    
        #if DEBUG
            NSLog("[%@][%@] Action, Start NWPathMonitor", SKNetworkMonitor.label, SKNetworkMonitor.identifier)
        #endif
        
        self.monitor.pathUpdateHandler = { newPath in
            
            #if DEBUG
                NSLog("[%@][%@] \(newPath)", SKNetworkMonitor.label, SKNetworkMonitor.identifier)
            #endif
            
            let result: SKNetworkMonitorStatus = SKNetworkMonitorStatus(newPath)
            self.pathUpdateHandler(result)
        }
        
        self.monitor.start(queue: self.implementQueue)
    }
    
    final func stopMonitor() {
        
        #if DEBUG
            NSLog("[%@][%@] Action, Cancel NWPathMonitor", SKNetworkMonitor.label, SKNetworkMonitor.identifier)
        #endif
        
        self.monitor.cancel()
    }
}
#endif
