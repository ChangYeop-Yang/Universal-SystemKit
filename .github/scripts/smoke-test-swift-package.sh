#!/usr/bin/env bash
set -euo pipefail

package_root=${GITHUB_WORKSPACE:-$PWD}
scratch_dir=$(mktemp -d "$RUNNER_TEMP/systemkit-consumer.XXXXXX")
trap 'rm -rf "$scratch_dir"' EXIT

# Give the local dependency the same package identity as the GitHub repository.
ln -s "$package_root" "$scratch_dir/Universal-SystemKit"
consumer_dir="$scratch_dir/Consumer"
source_dir="$consumer_dir/Sources/SystemKitSmokeTest"
mkdir -p "$source_dir"

cat > "$consumer_dir/Package.swift" <<'SWIFT'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SystemKitConsumer",
    platforms: [.macOS(.v10_15)],
    dependencies: [.package(path: "../Universal-SystemKit")],
    targets: [
        .executableTarget(
            name: "SystemKitSmokeTest",
            dependencies: [
                .product(name: "SystemKit", package: "Universal-SystemKit"),
                .product(name: "SystemKit_Objc", package: "Universal-SystemKit"),
            ]
        ),
    ]
)
SWIFT

cat > "$source_dir/main.swift" <<'SWIFT'
import Foundation
import SystemKit
import SystemKit_Objc

precondition(!SystemKit.version.isEmpty, "SystemKit did not report a version.")
precondition(NSStringFromClass(SKSecurity.self) == "SKSecurity", "SystemKit_Objc did not provide SKSecurity.")
print("The Swift package consumer used SystemKit and SystemKit_Objc successfully.")
SWIFT

swift run --package-path "$consumer_dir" --configuration release --verbose SystemKitSmokeTest
