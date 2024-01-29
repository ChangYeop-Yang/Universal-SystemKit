// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 * Copyright (c) 2023 Universal SystemKit. All rights reserved.
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
import PackageDescription

// The configuration of a Swift package.
let package = Package(
    // The name of the Swift package.
    name: InfoPackage.PackageName,
    // The list of minimum versions for platforms supported by the package.
    platforms: [
        // macOS 10.15 (Catalina) 이상의 운영체제부터 사용이 가능합니다.
        .macOS(SupportedPlatform.MacOSVersion.v10_15),
        
        // iOS 13 이상의 운영체제부터 사용이 가능합니다.
        .iOS(SupportedPlatform.IOSVersion.v13),
    ],
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    products: [
        // It is a module library related to Swift source code.
        .library(name: InfoPackage.PackageName, targets: [InfoPackage.PackageName]),
        
        // It is a module library related to Objective-C source code.
        .library(name: InfoPackage.PackageObjcName, targets: [InfoPackage.PackageObjcName])
    ],
    // The list of package dependencies.
    dependencies: [
        .package(url: RemotePackage.SwiftLog.path, from: RemotePackage.SwiftLog.from),
        .package(url: RemotePackage.SwiftHTTPTypes.path, from: RemotePackage.SwiftHTTPTypes.from),
    ],
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    targets: [
        .binaryTarget(name: LocalPackage.PLCrashReporter.name, path: LocalPackage.PLCrashReporter.path),
        .target(name: InfoPackage.PackageName,
                dependencies: [LocalPackage.PLCrashReporter.target, RemotePackage.SwiftLog.target, RemotePackage.SwiftHTTPTypes.target],
                path: InfoPackage.PackagePath),
        .target(name: InfoPackage.PackageObjcName, 
                path: InfoPackage.PackageObjcPath, 
                sources: ["Cryptor/SKSecurity.mm"],
                publicHeadersPath: ".",
                cSettings: [
                    .headerSearchPath(".")
                ])
    ],
    // The list of Swift versions with which this package is compatible.
    swiftLanguageVersions: [.v5]
)

#if swift(>=5.6)
// Add the documentation compiler plugin if possible
package.dependencies.append(
    .package(url: RemotePackage.SwiftDocC.path, from: RemotePackage.SwiftDocC.from)
)
#endif

// MARK: - Struct
public struct InfoPackage {
    
    // MARK: String Properties
    public static let PackageName: String = "SystemKit"
    
    public static let PackagePath: String = "Sources"
    
    public static let PackageObjcName: String = "SystemKit_Objc"
    
    public static let PackageObjcPath: String = "ObjcSources"
    
    public static let platforms: [PackageDescription.Platform] = [.iOS, .macOS]
}

// MARK: - Protocol
public protocol PackageProtocol {

    var name: String { get }
    var path: String { get }
    var target: Target.Dependency { get }
}

// MARK: - Enum
public enum LocalPackage: String, CaseIterable, PackageProtocol {
    
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
            let condition = TargetDependencyCondition.when(platforms: InfoPackage.platforms)
            return .target(name: self.name, condition: condition)
        }
    }
    
    public var name: String { return self.rawValue }
}

public enum RemotePackage: String, CaseIterable, PackageProtocol {
    
    /// 🌎 [Swift-docc-plugin - GitHub](https://github.com/apple/swift-docc-plugin)
    case SwiftDocC = "SwiftDocCPlugin"
    
    /// 🌎 [SwiftLog - GitHub](https://github.com/apple/swift-log)
    case SwiftLog = "swift-log"
    
    /// 🌎 [Swift-HTTP-Types- GitHub](https://github.com/apple/swift-http-types)
    case SwiftHTTPTypes = "swift-http-types"
    
    public var path: String {
        
        switch self {
        case .SwiftDocC:
            return "https://github.com/apple/swift-docc-plugin.git"
        case .SwiftLog:
            return "https://github.com/apple/swift-log.git"
        case .SwiftHTTPTypes:
            return "https://github.com/apple/swift-http-types.git"
        }
    }
    
    public var from: Version {
        
        switch self {
        case .SwiftDocC:
            // https://github.com/apple/swift-docc-plugin/releases/tag/1.2.0
            return Version(1, 2, 0)
        case .SwiftLog:
            // https://github.com/apple/swift-log/releases/tag/1.5.4
            return Version(1, 5, 4)
        case .SwiftHTTPTypes:
            // https://github.com/apple/swift-http-types/releases/tag/1.0.3
            return Version(1, 0, 3)
        }
    }
    
    public var target: Target.Dependency {
        
        switch self {
        case .SwiftDocC:
            let condition = TargetDependencyCondition.when(platforms: InfoPackage.platforms)
            return .target(name: self.name, condition: condition)
        case .SwiftLog:
            let condition = TargetDependencyCondition.when(platforms: InfoPackage.platforms)
            return .product(name: "Logging", package: self.name, condition: condition)
        case .SwiftHTTPTypes:
            let condition = TargetDependencyCondition.when(platforms: InfoPackage.platforms)
            return .product(name: "HTTPTypes", package: self.name, condition: condition)
        }
    }
    
    public var name: String { return self.rawValue }
}
