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

import Foundation
import SystemConfiguration

public class SKSystem: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static let shared: SKSystem = SKSystem()
    
    public static let label: String = "com.SystemKit.SKSystem"
    public let identifier: String = UUID().uuidString
}

// MARK: - Public Extension SKSystem
public extension SKSystem {
    
    typealias ApplicationVersionResult = (releaseVersion: String, bundleVersion: String)
    final func getApplicationVersion() -> Optional<ApplicationVersionResult> {
        
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }

        guard let releaseVersion = infoDictionary["CFBundleShortVersionString"] as? String,
              let bundleVersion = infoDictionary["CFBundleVersion"] as? String else { return nil }
    
        return ApplicationVersionResult(releaseVersion, bundleVersion)
    }
    
    typealias DeviceMemoryResult = (usage: Float, total: Float)
    func getDeviceMemoryUnitMB() -> DeviceMemoryResult {
        
        var usageMegaBytes = Float.zero
        let totalMegaBytes = Float(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0
        
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
        
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info( mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        if result == KERN_SUCCESS {
            usageMegaBytes = Float(info.resident_size) / 1024.0 / 1024.0
        }
        
        return DeviceMemoryResult(usageMegaBytes, totalMegaBytes)
    }
}

// MARK: - Public Extension SKSystem With iOS Platform
#if os(iOS)
import UIKit
public extension SKSystem {
    
    typealias SystemVersionResult = (systemName: String, systemVersion: String)
    final func getOperatingSystemVersion() -> SystemVersionResult {
        
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
    
        return SystemVersionResult(systemName, systemVersion)
    }
    
    typealias DeviceInformationResult = (deviceName: String, deviceModel: String, localizedModel: String)
    final func getDeviceInformation() -> DeviceInformationResult {
        
        let deviceName = UIDevice.current.name
        let deviceModel = UIDevice.current.model
        let localizedModel = UIDevice.current.localizedModel
        
        return DeviceInformationResult(deviceName, deviceModel, localizedModel)
    }
}
#endif

// MARK: - Public Extension SKSystem With macOS Platform
#if os(macOS)
import Cocoa
public extension SKSystem {
    
    final func getOperatingSystemVersion() -> OperatingSystemVersion {

        let operatingSystemVersion = ProcessInfo.processInfo.operatingSystemVersion
        
        return operatingSystemVersion
    }
    
    @available(macOS 10.12, *)
    final func getOperatingSystemName() -> String {
        
        let version = getOperatingSystemVersion()
        
        // macOS Sierra ~ macOS Catalina 운영체제는 Minor Version까지 확인
        let lowerVersion: () -> String = {
            switch version.minorVersion {
            // macOS Sierra
            case 12: return macOSSystemVersion.Sierra.name
            // macOS High Sierra
            case 13: return macOSSystemVersion.HighSierra.name
            // macOS Mojave
            case 14: return macOSSystemVersion.Mojave.name
            // macOS Catalina
            case 15: return macOSSystemVersion.Catalina.name
            default: return "UNKNOWN"
            }
        }
        
        switch version.majorVersion {
        // Above macOS Sierra
        case 10: return lowerVersion()
        // Above macOS BigSur
        case 11: return macOSSystemVersion.BigSur.name
        // Above macOS Monterey
        case 12: return macOSSystemVersion.Monterey.name
        // Above macOS Ventura
        case 13: return macOSSystemVersion.Ventura.name
        // macOS 10.12 미만의 운영체제이거나 아직 알려지지 않은 운영체제
        default: return "UNKNOWN"
        }
    }
        
    @available(macOS 10.1, *)
    final func getConsoleUserName() -> Optional<String> {

        let forKey: String = "GetConsoleUser"
        
        // Creates a new session used to interact with the dynamic store maintained by the System Configuration server.
        let store = SCDynamicStoreCreate(nil, forKey as CFString, nil, nil)

        // Returns information about the user currently logged into the system.
        guard let result = SCDynamicStoreCopyConsoleUser(store, nil, nil) else {
            return UserDefaults.standard.string(forKey: forKey)
        }

        UserDefaults.standard.setValue(result as String, forKey: forKey)

        // MARK: https://developer.apple.com/library/archive/qa/qa1133/_index.html
        return result as String
    }
    
    /**
        - NOTE: [Apple Document](https://developer.apple.com/documentation/apple-silicon/about-the-rosetta-translation-environment)
        - Returns: The example function returns the value 0 for a native process, 1 for a translated process, and -1 when an error occurs.
     */
    @available(macOS 10.0, *)
    final func isRosettaTranslatedProcess() -> TranslatedRosettaResult {
        
        var ret: Int = Int.zero
        var size: size_t = MemoryLayout.size(ofValue: ret)
        
        let flag: String = "sysctl.proc_translated"
        if sysctlbyname(flag, &ret, &size, nil, Int.zero) == EOF {
            if errno == ENOENT { return .native }
            return .error
        }
        
        let rawValue = Int32(ret)
        return TranslatedRosettaResult(rawValue: rawValue) ?? .error
    }
    
    @available(macOS 10.10, *)
    final func getRunningProcessUsingCPU() -> Double {

        var threadsList: thread_act_array_t?
        var totalUsageOfCPU: Double = Double.zero
        var threadsCount = mach_msg_type_number_t(Int32.zero)
        
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }

        if threadsResult == KERN_SUCCESS, let threadsList = threadsList {
            
            for index in mach_msg_type_number_t.zero..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(threadsList[Int(index)], thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }

                guard infoResult == KERN_SUCCESS else { break }

                let threadBasicInfo = threadInfo as thread_basic_info
                if (threadBasicInfo.flags & TH_FLAGS_IDLE) == Int32.zero {
                    totalUsageOfCPU = (totalUsageOfCPU + (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0))
                }
            }
        }
        
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))

        return totalUsageOfCPU
    }
    
    typealias SKSystemNotrizeResult = (SKNotrizeResult) -> Swift.Void
    @available(macOS 10.15.4, *)
    final func checkNotrize(atPath: String, completion: @escaping SKSystemNotrizeResult) {
        
        // 공증 작업 대상이 현재 경로에 존재하는지 확인합니다.
        guard FileManager.default.fileExists(atPath: atPath) else { return }
                
        let terminationHandler: SKProcess.SKProcessTerminationHandler = { process in
            
            guard let stream = process.standardError as? Pipe else { return }
            
            let availableData = stream.fileHandleForReading.availableData
            guard availableData.count > Int.zero else { return }
            
            guard let description = String(data: availableData, encoding: .utf8) else { return }
            
            NSLog("[%@][%@] Completion, Notrize Target Application: %@", SKSystem.label, self.identifier, description)
            
            let sequence = description.split(whereSeparator: \.isNewline)
            
            guard let notrize = sequence[SKNotrizeResultIndex.result.rawValue].split(whereSeparator: \.isWhitespace).last else { return }
            
            // 공증 작업이 수행되지 않은 애플리케이션인 경우
            if notrize == "rejected" {
                let result = SKNotrizeResult(result: String(notrize), source: nil, origin: nil, path: atPath)
                completion(result)
                return
            }
            
            // 공증 작업이 정상적으로 수행 된 애플리케이션인 경우
            if notrize == "accepted" {
                guard let source = sequence[SKNotrizeResultIndex.source.rawValue].split(separator: "=").last,
                      let origin = sequence[SKNotrizeResultIndex.origin.rawValue].split(separator: "=").last else { return }
                
                let result = SKNotrizeResult(result: String(notrize), source: String(source), origin: String(origin), path: atPath)
                completion(result)
                return
            }
        }
        
        let standardError: Pipe = Pipe()
        
        let arguments: [String] = ["-a", "-vvv", "-t", "install", atPath]
        SKProcess.shared.run(launchPath: "/usr/sbin/spctl", arguments: arguments,
                             standardError: standardError, terminationHandler: terminationHandler)
    }
}
#endif
