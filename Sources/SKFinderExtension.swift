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
import FinderSync

@available(iOS, unavailable)
public class SKFinderExtension: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static let shared: SKFinderExtension = SKFinderExtension()
    public static let label: String = "com.SystemKit.SKFinderExtension"
    
    public let identifier: String = UUID().uuidString
    private let launchPath: String = "/usr/bin/pluginkit"
    
    // MARK: - Initalize
    private override init() { super.init() }
}

// MARK: - Public Extension SKFinderExtension With Properties
public extension SKFinderExtension {
    
    @available(macOS 10.14, *)
    var isExtensionEnabled: Bool { FIFinderSyncController.isExtensionEnabled }
}

// MARK: - Public Extension SKFinderExtension With Method
public extension SKFinderExtension {
    
    @available(macOS 10.12, *)
    final func append(extensionPath: String, waitUntilExit: Bool) {
        
        NSLog("[%@][%@] Action, Append Application Finder Extension", SKFinderExtension.label, self.identifier)
        
        let arguments: Array<String> = ["-a", extensionPath]
        SKProcess.shared.run(launchPath: self.launchPath, arguments: arguments, waitUntilExit: waitUntilExit)
    }
    
    @available(macOS 10.12, *)
    final func enable(extensionPath: String, waitUntilExit: Bool) {
        
        NSLog("[%@][%@] Action, Enable Application Finder Extension", SKFinderExtension.label, self.identifier)
        
        let arguments: Array<String> = ["-e", "use", "-i", extensionPath]
        SKProcess.shared.run(launchPath: self.launchPath, arguments: arguments, waitUntilExit: waitUntilExit)
    }
    
    @available(macOS 10.12, *)
    final func disable(extensionPath: String, waitUntilExit: Bool) {
        
        NSLog("[%@][%@] Action, Disable Application Finder Extension", SKFinderExtension.label, self.identifier)
        
        let arguments: Array<String> = ["-e", "ignore", "-i", extensionPath]
        SKProcess.shared.run(launchPath: self.launchPath, arguments: arguments, waitUntilExit: waitUntilExit)
    }
}
#endif
