// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 * Copyright (c) 2022 Universal SystemKit. All rights reserved.
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
#if os(macOS) || os(iOS)
import PackageDescription

// MARK: - Object Properties
private let namePackage: String = "SystemKit"

// The configuration of a Swift package.
let package = Package(
    // The name of the Swift package.
    name: namePackage,
    
    // The list of minimum versions for platforms supported by the package.
    platforms: [
        // macOS 10.13 (High Sierra) 이상의 운영체제부터 사용이 가능합니다.
        .macOS(SupportedPlatform.MacOSVersion.v10_13),
        
        // iOS 11 이상의 운영체제부터 사용이 가능합니다.
        .iOS(SupportedPlatform.IOSVersion.v11),
    ],
    
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    products: [
        .library(name: namePackage, targets: [namePackage]),
    ],
    
    // The list of package dependencies.
    dependencies: [],
    
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    targets: [
        .binaryTarget(name: LocalPackage.PLCrashReporter.name, path: LocalPackage.PLCrashReporter.path),
        .target(name: namePackage, dependencies: [LocalPackage.PLCrashReporter.target], path: "Sources"),
    ]
)

// MARK: - Enum
public enum LocalPackage: String, CaseIterable {
    
    /// [PLCrashReporter - GitHub](https://www.github.com/microsoft/plcrashreporter)
    case PLCrashReporter = "CrashReporter"
    
    public var path: String {
        switch self {
        case .PLCrashReporter:
            return "Frameworks/CrashReporter.xcframework"
        }
    }
    
    public var target: Target.Dependency {
        switch self {
        case .PLCrashReporter:
            let platforms: [PackageDescription.Platform] = [.iOS, .macOS]
            return .target(name: self.name, condition: .when(platforms: platforms))
        }
    }
    
    public var name: String { return self.rawValue }
}
#else
fatalError("[SystemKit] Error, Unsupported Operating System")
#endif
