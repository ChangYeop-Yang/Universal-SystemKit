/*
 * Copyright (c) 2023 Universal-SystemKit. All rights reserved.
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
#if os(iOS) || os(macOS)
import Darwin
import Foundation

// MARK: - Enum

/// The network interface family (IPv4 or IPv6).
public enum SKFamily: Int {
    
    /// [IPv4](https://en.wikipedia.org/wiki/Internet_Protocol_version_4)
    case ipv4
    
    /// [IPv6](https://en.wikipedia.org/wiki/IPv6)
    case ipv6
    
    /// Used in case of errors.
    case other
    
    // MARK: Enum Computed Properties
    public var toString: String {
        
        // String representation of the address family.
        switch self {
        case .ipv4:
            return "IPv4"
        case .ipv6:
            return "IPv6"
        case .other:
            return "Other"
        }
    }
}

// MARK: - Struct
public struct SKInterface: Identifiable, Codable {
    
    public var id: String = UUID().uuidString
    
    /// Extracted from `sysctl` based on `if_nametoindex`.
    public let macAddress: Optional<String>
    
    /// Extracted from `ifaddrs->ifa_netmask`, supports both IPv4 and IPv6.
    public let netmask: Optional<String>
    
    /// Extracted from `ifaddrs->ifa_addr`, supports both IPv4 and IPv6.
    public let ipAddress: Optional<String>
    
    /// Extracted from `ifaddrs->ifa_dstaddr`. Not applicable for IPv6.
    public let broadcastAddress: Optional<String>
    
    /// Field `ifaddrs->ifa_name`.
    public let interfaceName: String
    
    /// Field `ifaddrs->ifa_addr->sa_family`.
    public let interfaceFamily: String
    
    /// `IFF_UP` flag of `ifaddrs->ifa_flags`.
    public let up: Bool
    
    /// `IFF_RUNNING` flag of `ifaddrs->ifa_flags`.
    public let running: Bool
    
    /// `IFF_LOOPBACK` flag of `ifaddrs->ifa_flags`.
    public let loopBack: Bool
    
    /// `IFF_MULTICAST` flag of `ifaddrs->ifa_flags`.
    public let multicastSupported: Bool
    
    /// `IFF_BROADCAST` flag of `ifaddrs->ifa_flags`.
    public let broadcastSupported: Bool
    
    // MARK: Initalize
    public init(ipAddress: Optional<String>, macAddress: Optional<String>,
                broadcastAddress: Optional<String>, netmask: Optional<String>,
                interfaceName: String, interfaceFamily: String, ifaFlags: Int32) {
        
        self.netmask = netmask
        self.ipAddress = ipAddress
        self.macAddress = macAddress
        self.broadcastAddress = broadcastAddress
        
        self.interfaceName = interfaceName
        self.interfaceFamily = interfaceFamily
        
        self.up = (ifaFlags & IFF_UP) == IFF_UP
        self.running = (ifaFlags & IFF_RUNNING) == IFF_RUNNING
        self.loopBack = (ifaFlags & IFF_LOOPBACK) == IFF_LOOPBACK
        self.multicastSupported = (ifaFlags & IFF_MULTICAST) == IFF_MULTICAST
        self.broadcastSupported = (ifaFlags & IFF_BROADCAST) == IFF_BROADCAST
    }
}
#endif
