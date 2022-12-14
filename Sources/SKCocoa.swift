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

// swiftlint:disable all
#if os(macOS)
import Cocoa

public class SKCocoa: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKCocoa"
    public static var identifier: String = "7304B2E2-9AB3-4046-8D9C-0B1E6A981874"
    public static let shared: SKCocoa = SKCocoa()
    
    // MARK: - Initalize
    private override init() { super.init() }
}

// MARK: - Public Extension SKCocoa
public extension SKCocoa {

    /**
        `NSStoryboard`를 통해서 제작 된 `NSViewController`를 가져올 수 있는 함수입니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Returns: `Optional<T>`
     */
    final func loadViewController<T>(name: String, withIdentifier: String, type: T.Type) -> Optional<T> {
        
        #if DEBUG
            NSLog("[%@][%@] Action, Load NSViewController: %@", SKCocoa.label, SKCocoa.identifier, withIdentifier)
        #endif
        
        let storyboard = NSStoryboard(name: name, bundle: nil)
        return storyboard.instantiateController(withIdentifier: withIdentifier) as? T
    }
    
    /**
        `NSNib`를 통해서 제작 된 `NSView`를 가져올 수 있는 함수입니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Returns: `Optional<T>`
     */
    final func loadCustomView<T>(name stringLiteral: String, type: T.Type) -> Optional<T> {

        #if DEBUG
            NSLog("[%@][%@] Action, Load CustomView: %@", SKCocoa.label, SKCocoa.identifier, stringLiteral)
        #endif

        var topLevelObjects: Optional<NSArray> = nil

        let name: NSNib.Name = NSNib.Name(stringLiteral: stringLiteral)
        guard Bundle.main.loadNibNamed(name, owner: self, topLevelObjects: &topLevelObjects) else { return nil }

        let viewObjects = topLevelObjects?.filter { $0 is NSView }
        guard let mainView = viewObjects?.first as? T else { return nil }

        return mainView
    }
}
#endif
