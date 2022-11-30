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

#if os(iOS)
import UIKit
import Foundation

// MARK: - Public Extension SKSystem With iOS Platform
public extension SKSystem {

    /**
        현재 iPhone 장비에서 사용하고 있는 운영체제 정보를 가져오는 함수입니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Returns: `SystemVersionResult`
     */
    typealias SystemVersionResult = (systemName: String, systemVersion: String)
    final func getOperatingSystemVersion() -> SystemVersionResult {
        
        // The name of the operating system running on the device.
        let systemName = UIDevice.current.systemName
        
        // The current version of the operating system.
        let systemVersion = UIDevice.current.systemVersion
    
        return SystemVersionResult(systemName, systemVersion)
    }
    
    /**
        iPhone 제품 정보 (UIDevice.Name, UIDevice.Model, UIDevice.LocalizedModel)를 가져오는 함수입니다.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Returns: `DeviceInformationResult`
     */
    typealias DeviceInformationResult = (deviceName: String, deviceModel: String, localizedModel: String)
    final func getDeviceInformation() -> DeviceInformationResult {
        
        // The name of the device.
        let deviceName: String = UIDevice.current.name
        
        // Possible examples of model strings are ”iPhone” and ”iPod touch”.
        let deviceModel: String = UIDevice.current.model
        
        // The value of this property is a string that contains a localized version of the string returned from model.
        let localizedModel: String = UIDevice.current.localizedModel
        
        return DeviceInformationResult(deviceName, deviceModel, localizedModel)
    }
    
    /**
        `Machine Hardware Platform` 바탕으로 iPhone 제품명을 가져오는 함수입니다.

        - SeeAlso: [Apple Device Database](https://appledb.dev)
        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - Parameters:
            - name: `SKSystemMachineSystemResult.machineHardwarePlatform` 값을 입력받습니다.
        - Returns: `Optional<SKSystemMachineSystemResult>`
     */
    final func getRegularProductName(name: String) -> String {

        switch name {
        // MARK: iPhone 4 Product
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return "iPhone 4"
        case "iPhone4,1":
            return "iPhone 4s"

        // MARK: iPhone 5 Product
        case "iPhone5,1", "iPhone5,2":
            return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":
            return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":
            return "iPhone 5s"

        // MARK: iPhone 6 Product
        case "iPhone7,2":
            return "iPhone 6"
        case "iPhone7,1":
            return "iPhone 6 Plus"
        case "iPhone8,1":
            return "iPhone 6s"
        case "iPhone8,2":
            return "iPhone 6s Plus"

        // MARK: iPhone 7 Product
        case "iPhone9,1", "iPhone9,3":
            return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":
            return "iPhone 7 Plus"

        // MARK: iPhone 8 Product
        case "iPhone10,1", "iPhone10,4":
            return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":
            return "iPhone 8 Plus"

        // MARK: iPhone X Series Product
        case "iPhone10,3", "iPhone10,6":
            return "iPhone X"
        case "iPhone11,2":
            return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":
            return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"

        // MARK: iPhone 11 Product
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"

        // MARK: iPhone 12 Product
        case "iPhone13,1":
            return "iPhone 12 mini"
        case "iPhone13,2":
            return "iPhone 12"
        case "iPhone13,3":
            return "iPhone 12 Pro"
        case "iPhone13,4":
            return "iPhone 12 Pro Max"

        // MARK: iPhone 13 Product
        case "iPhone14,4":
            return "iPhone 13 mini"
        case "iPhone14,5":
            return "iPhone 13"
        case "iPhone14,2":
            return "iPhone 13 Pro"
        case "iPhone14,3":
            return "iPhone 13 Pro Max"

        // MARK: iPhone 14 Product
        case "iPhone14,7":
            return "iPhone 14"
        case "iPhone14,8":
            return "iPhone 14 Plus"
        case "iPhone15,2":
            return "iPhone 14 Pro"
        case "iPhone15,3":
            return "iPhone 14 Pro Max"

        // MARK: iPhone SE Product
        case "iPhone8,4":
            return "iPhone SE"
        case "iPhone12,8":
            return "iPhone SE (2nd generation)"
        case "iPhone14,6":
            return "iPhone SE (3rd generation)"

        default:
            NSLog("[%@][%@] Error, Unknown IPhone Deivce Name", SKSystem.label, SKSystem.identifier)
            return String.init()
        }
    }
}
#endif
