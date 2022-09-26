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
import Cocoa
import Foundation

public class SKPermission: SKClass {
    
    // MARK: - Object Properties
    public static let shared: SKPermission = SKPermission()
    public static var label: String = "com.SystemKit.SKPermission"
    
    public var identifier: String = UUID().uuidString
}

// MARK: - Public SKPermission Extension
public extension SKPermission {
    
    @available(macOS 10.15, *)
    final func isFullDiskAccessPermission() -> Bool {
        
        let atPath: String = "/Library/Application Support/com.apple.TCC/TCC.db"
        return FileManager.default.isReadableFile(atPath: atPath)
    }
    
    @available(macOS 10.12, *)
    final func managePrivacyPermission(service: SKPermissionServiceName = .All, bundlePath: String) {
        
        let arguments: [String] = ["reset", service.rawValue, bundlePath]
        SKProcess.shared.run(launchPath: "/usr/bin/tccutil", arguments: arguments)
    }
    
    final func openPreferencePane(path: String) -> Bool {
        
        guard let url: URL = URL(string: path) else { return false }
        return NSWorkspace.shared.open(url)
    }
}
#endif
