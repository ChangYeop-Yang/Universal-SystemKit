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
import AppKit

public class SKPermission: SKClass {
    
    // MARK: - Object Properties
    public static let shared: SKPermission = SKPermission()
    public static var label: String = "com.SystemKit.SKPermission"
    public static var identifier: String = "6152CB47-C012-4AB2-8625-90836CCB8541"
}

// MARK: - Private Extension SKPermission
private extension SKPermission {
    
}

// MARK: - Public Extension SKPermission
public extension SKPermission {
    
    /**
        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Requires: Use more than `macOS Catalina (10.15)`
        - Returns: `Bool`
     */
    @available(macOS 10.15, *)
    final func isFullDiskAccessPermission() -> Bool {
        
        let atPath: String = "/Library/Application Support/com.apple.TCC/TCC.db"
        return FileManager.default.isReadableFile(atPath: atPath)
    }
    
    /**
        `PreferencePane` 경로를 입력받아서 `시스템 환경설정 (System Preference)` 창을 켭니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Requires: Use more than `macOS Sierra (10.12)`
        - Parameters:
            - service: `SKPermissionServiceName` 입력받는 변수
            - bundlePath: Application Bundle Path를 입력받는 변수
        - Returns: `Bool`
     */
    @available(macOS 10.12, *)
    final func managePrivacyPermission(service: SKPermissionServiceName, bundlePath: String) {
        
        #if DEBUG
            NSLog("[%@][%@] Action, Reset tccutil: %@, %@",
                  SKPermission.label, SKPermission.identifier, bundlePath, service.rawValue)
        #endif
        
        let arguments: [String] = ["reset", service.rawValue, bundlePath]
        SKProcess.shared.run(launchPath: "/usr/bin/tccutil", arguments: arguments)
    }
    
    /**
        `PreferencePane` 경로를 입력받아서 `시스템 환경설정 (System Preference)` 창을 켭니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Requires: `@discardableResult`
        - Parameters:
            - path: `PreferencePane` 경로를 입력받는 변수
        - Returns: `Bool`
     */
    @discardableResult
    final func openPreferencePane(path: String) -> Bool {
        
        #if DEBUG
            NSLog("[%@][%@] Action, Open PreferencePane: %@", SKPermission.label, SKPermission.identifier, path)
        #endif
        
        guard let url: URL = URL(string: path) else { return false }
        
        return NSWorkspace.shared.open(url)
    }
}
#endif
