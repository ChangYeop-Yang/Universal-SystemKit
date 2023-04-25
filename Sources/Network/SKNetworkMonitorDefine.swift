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

#if os(iOS) || os(macOS)
import Network
import Foundation

// MARK: - Enum
@available(iOS 12, macOS 10.14, *)
public enum SKNetworkStatusSymbols: String {
    
    case satisfied = "wifi"
    case unsatisfied = "wifi.slash"
    case requiresConnection = "wifi.exclamationmark"
}

@available(iOS 12, macOS 10.14, *)
public enum SKNetworkConnectionType: String {
    
    case unknown = "unknown"
    
    /// [Wi-Fi - Wikipedia](https://en.wikipedia.org/wiki/Wi-Fi)
    case wifi = "wifi"
    
    /// [Ethernet - Wikipedia](https://en.wikipedia.org/wiki/Ethernet)
    case ethernet = "ethernet"
    
    /// [Cellular - Wikipedia](https://en.wikipedia.org/wiki/Cellular_network)
    case cellular = "cellular"
    
    /// [Loopback - Wikipedia](https://en.wikipedia.org/wiki/Loopback)
    case loopback = "loopback"
}

// MARK: - Struct
@available(iOS 12, macOS 10.14, *)
public struct SKNetworkMonitorStatus {
    
    // MARK: Object Properties
    public let newPath: NWPath
    
    // MARK: - Initalize
    public init(_ newPath: NWPath) {
        self.newPath = newPath
    }
    
    // MARK: - Computed Properties
    
    /// - NOTE: [NWPath.Status](https://developer.apple.com/documentation/network/nwpath/status)
    public var status: SKNetworkMonitor.SKNetworkStatus {
        
        // 현재 디바이스에 대한 네트워크 연결 상태를 확인합니다.
        switch self.newPath.status {
            
        // The path is not currently available, but establishing a new connection may activate the path.
        case .requiresConnection:
            return SKNetworkMonitor.SKNetworkStatus(false, SKNetworkStatusSymbols.requiresConnection)
            
        // The path is not available for use.
        case .unsatisfied:
            return SKNetworkMonitor.SKNetworkStatus(false, SKNetworkStatusSymbols.unsatisfied)
        
        // The path is available to establish connections and send data.
        case .satisfied:
            return SKNetworkMonitor.SKNetworkStatus(true, SKNetworkStatusSymbols.satisfied)
        
        @unknown default:
            NSLog("[%@][%@] Error, Invaild NWPath.Status", SKNetworkMonitor.label, SKNetworkMonitor.identifier)
            return SKNetworkMonitor.SKNetworkStatus(false, SKNetworkStatusSymbols.unsatisfied)
        }
    }
    
    /// - NOTE: [NWInterface.InterfaceType](https://developer.apple.com/documentation/network/nwinterface/interfacetype)
    public var connectionType: SKNetworkConnectionType {
        
        // The network interface type used for communication over Wi-Fi networks.
        if self.newPath.usesInterfaceType(NWInterface.InterfaceType.wifi) {
            return SKNetworkConnectionType.wifi
        }
        
        // The network interface type used for communication over cellular networks.
        if self.newPath.usesInterfaceType(NWInterface.InterfaceType.cellular) {
            return SKNetworkConnectionType.cellular
        }
        
        // The network interface type used for communication over local loopback networks.
        if self.newPath.usesInterfaceType(NWInterface.InterfaceType.loopback) {
            return SKNetworkConnectionType.loopback
        }
        
        // The network interface type used for communication over wired Ethernet networks.
        if self.newPath.usesInterfaceType(NWInterface.InterfaceType.wiredEthernet) {
            return SKNetworkConnectionType.ethernet
        }
        
        // The network interface type used for communication over virtual networks or networks of unknown types.
        return SKNetworkConnectionType.unknown
    }
}
#endif
