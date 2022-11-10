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
import Cocoa
import Foundation

public class SKCocoaAlert: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static var label: String = ""
    public static var identifier: String = ""
    public static let shared: SKCocoaAlert = SKCocoaAlert()
    
    // MARK: - Initalize
    private override init() { super.init() }
}

// MARK: - Public Extension SKCocoaAlert
public extension SKCocoaAlert {
    
    @discardableResult
    final func runModel(alertStyle: NSAlert.Style = .informational,
                        informativeText: String, messageText: String,
                        icon: Optional<NSImage> = nil,
                        delegate: Optional<NSAlertDelegate> = nil) -> NSApplication.ModalResponse {
        
        let alert: NSAlert = NSAlert()
        alert.informativeText = informativeText
        alert.messageText = messageText
        alert.alertStyle = alertStyle
        alert.delegate = delegate
        
        // NSAlert 표시할 아이콘이 존재하는 경우에는 아이콘을 설정합니다.
        if let image = icon { alert.icon = image }
        
        return alert.runModal()
    }
}
#endif
