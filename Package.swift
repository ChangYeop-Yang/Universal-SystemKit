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
private let dependenciesTarget: [Target.Dependency] = PackageAttribute.allCases.compactMap { item in item.product }
private let dependenciesPackage: [Package.Dependency] = PackageAttribute.allCases.compactMap { item in item.package }

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
                                              //FrameworkAttribute.PLCrashReporter.name]),
    ],
    
    // The list of package dependencies.
    dependencies: dependenciesPackage,
    
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    targets: [
        .target(name: namePackage, dependencies: dependenciesTarget, path: "Sources"),
        //.binaryTarget(name: FrameworkAttribute.PLCrashReporter.name, path: FrameworkAttribute.PLCrashReporter.path)
    ]
)

// MARK: - Enum
public enum FrameworkAttribute: String, CaseIterable {
    
    /// [PLCrashReporter - GitHub](https://github.com/microsoft/plcrashreporter)
    case PLCrashReporter = "CrashReporter"
    
    public var path: String {
        switch self {
        case .PLCrashReporter:
            return "Frameworks/PLCrashReporter/CrashReporter.xcframework"
        }
    }
    
    public var name: String { return self.rawValue }
}

public enum PackageAttribute: String, CaseIterable {
    
    /// [Apple Collections OpenSource](https://github.com/apple/swift-collections)
    case Collections = "Collections"
    
    /// [Swift Algorithm](https://github.com/apple/swift-algorithms)
    case Algorithms = "Algorithms"
    
    public var url: String {
        switch self {
        case .Collections:
            return "https://github.com/apple/swift-collections.git"
        case .Algorithms:
            return "https://github.com/apple/swift-algorithms.git"
        }
    }
    
    public var packageName: String {
        switch self {
        case .Collections:
            return "swift-collections"
        case .Algorithms:
            return "swift-algorithms"
        }
    }
    
    public var upToNextMajor: Range<Version> {
        switch self {
        case .Collections:
            let fromVersion = Version(stringLiteral: "1.0.3")
            return .upToNextMajor(from: fromVersion)
        case .Algorithms:
            let fromVersion = Version(stringLiteral: "1.0.0")
            return .upToNextMajor(from: fromVersion)
        }
    }
    
    public var package: Package.Dependency {
        return Package.Dependency.package(url: self.url, self.upToNextMajor)
    }
    
    public var product: Target.Dependency {
        return Target.Dependency.product(name: self.rawValue, package: self.packageName)
    }
}

#else
fatalError("[SystemKit] Error, Unsupported Operating System")
#endif
