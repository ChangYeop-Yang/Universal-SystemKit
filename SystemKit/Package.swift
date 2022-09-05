// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Object Properties
private let namePackage: String = "SystemKit"
private let dependenciesTarget: [Target.Dependency] = PackageAttribute.allCases.compactMap { item in item.product }
private let dependenciesPackage: [Package.Dependency] = PackageAttribute.allCases.compactMap { item in item.package }

let package = Package(
    name: namePackage,
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: namePackage, targets: ["SystemKit"]),
    ],
    dependencies: dependenciesPackage,
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: namePackage, dependencies: dependenciesTarget),
        .testTarget(name: "SystemKitTests", dependencies: ["SystemKit"]),
    ]
)

// MARK: - Enum
public enum PackageAttribute: String, CaseIterable {
    
    /// [Apple SwiftLog OpenSource](https://github.com/apple/swift-log)
    case Logging = "Logging"
    
    /// [Apple Collections OpenSource](https://github.com/apple/swift-collections)
    case Collections = "Collections"
    
    /// [Swift System](https://github.com/apple/swift-system)
    case SystemPackage = "SystemPackage"
    
    public var url: String {
        switch self {
        case .Collections:
            return "https://github.com/apple/swift-collections.git"
        case .Logging:
            return "https://github.com/apple/swift-log.git"
        case .SystemPackage:
            return "https://github.com/apple/swift-system.git"
        }
    }
    
    public var packageName: String {
        switch self {
        case .Logging:
            return "swift-log"
        case .Collections:
            return "swift-collections"
        case .SystemPackage:
            return "swift-system"
        }
    }
    
    public var upToNextMajor: Range<Version> {
        switch self {
        case .Logging:
            let fromVersion = Version(stringLiteral: "1.0.0")
            return .upToNextMajor(from: fromVersion)
        case .Collections:
            let fromVersion = Version(stringLiteral: "1.0.3")
            return .upToNextMajor(from: fromVersion)
        case .SystemPackage:
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
