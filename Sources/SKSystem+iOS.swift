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
