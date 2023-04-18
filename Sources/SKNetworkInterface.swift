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

import Logging

@objc public class SKNetworkInterface: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static let label: String = "com.SystemKit.SKNetworkInterface"
    public static let identifier: String = "45BC7AF3-346F-44DE-A370-96BA0E14AC40"
    public static let shared: SKNetworkInterface = SKNetworkInterface()
    
    // MARK: - Initalize
    private override init() { super.init() }
}

// MARK: - Private Extension SKNetworkInterface
private extension SKNetworkInterface {
    
    /**
        네트워크 인터페이스 명칭을 가져오는 함수입니다.

        - Version: `1.0.0`
        - Returns: `Optional<String>`
     */
    final func extractInterfaceName(_ ifaName: UnsafeMutablePointer<CChar>) -> Optional<String> {
        
        guard let name = String(cString: ifaName, encoding: .utf8) else {
            logger.error("[SKNetworkInterface] Could't read network interface name")
            return nil
        }
        
        return name
    }
    
    /**
        이더넷 (Ethernet)의 물리적인 주소 가져오는 함수입니다.

        - NOTE: [MAC Address](https://terms.naver.com/entry.naver?docId=862689&cid=42346&categoryId=42346)
        - Version: `1.0.0`
        - Returns: `Optional<String>`
     */
    final func extractAddressMAC(_ interfaceName: String) -> Optional<String> {
        
        let lengthMACAddress: Int = 6
        
        // 입력받은 네트워크 인터페이스의 이름을 해당 인터페이스의 인덱스로 변환합니다.
        let indexBSD: UInt32 = if_nametoindex(interfaceName)
        
        // 입력받은 인터페이스 이름이 유효하지 않거나 인터페이스 인덱스를 가져오지 못하는 경우
        if indexBSD == UInt32.zero {
            logger.error("[SKNetworkInterface] Could't find index for bsd name")
            return nil
        }
        
        let dataBSD = Data(interfaceName.utf8)

        var length: size_t = size_t.zero
        var info: Array<Int32> = [CTL_NET, AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST, Int32(indexBSD)]

        if sysctl(&info, u_int(lengthMACAddress), nil, &length, nil, Int.zero) < Int32.zero {
            logger.error("[SKNetworkInterface] Could't determine length of info data structure")
            return nil
        }

        var buffer: Array<CChar> = [CChar](unsafeUninitializedCapacity: length, initializingWith: { buffer, initializedCount in
            for index in size_t.zero..<length { buffer[index] = CChar.zero }
            initializedCount = length
        })

        if sysctl(&info, u_int(lengthMACAddress), &buffer, &length, nil, Int.zero) < Int32.zero {
            logger.error("[SKNetworkInterface] Could't read info data structure")
            return nil
        }

        let infoData = Data(bytes: buffer, count: length)
        let startIndex = MemoryLayout<if_msghdr>.stride + 1
        guard let rangeOfToken = infoData[startIndex...].range(of: dataBSD) else { return nil }
        
        let lower = rangeOfToken.upperBound
        let upper = lower + lengthMACAddress
        return infoData[lower..<upper].map { element in String(format: "%02x", element) }.joined(separator: ":")
    }
    
    /**
        IPv4 주소 또는 IPv6 주소 형태를 가진 IP주소를 가져오는 함수입니다.
     
        - NOTE: [IP address](https://terms.naver.com/entry.naver?docId=856811&cid=42346&categoryId=42346)
        - Version: `1.0.0`
        - Returns: `Optional<String>`
     */
    final func extractAddress(_ sockaddr: UnsafeMutablePointer<sockaddr>?) -> Optional<String> {
        
        guard let address = sockaddr else { return nil }
        
        switch address.pointee.sa_family {
        case sa_family_t(AF_INET):
            logger.info("[SKNetworkInterface] Extracting IPv4 address information.")
            return extractAddressIPv4(address)
            
        case sa_family_t(AF_INET6):
            logger.info("[SKNetworkInterface] Extracting IPv6 address information.")
            return extractAddressIPv6(address)
        
        default:
            logger.error("[SKNetworkInterface] Unable to extractive address information from the interface.")
            return nil
        }
    }
    
    /**
        IPv4 주소를 가져오는 함수입니다.

        - NOTE: [IPv4](https://terms.naver.com/entry.naver?docId=3586555&cid=59277&categoryId=59278)
        - Version: `1.0.0`
        - Returns: `Optional<String>`
     */
    final func extractAddressIPv4(_ address: UnsafeMutablePointer<sockaddr>) -> Optional<String> {
        
        // getnameinfo 함수를 통하여 입력받은 네트워크 인터페이스의 IPv4 주소를 가져옵니다.
        let buffer = address.withMemoryRebound(to: sockaddr.self, capacity: 1) { pointer in
            
            var hostname = Array<CChar>.init(repeating: CChar.zero, count: Int(NI_MAXHOST))
            
            let result = getnameinfo(&address.pointee, socklen_t(address.pointee.sa_len), &hostname,
                                     socklen_t(hostname.count), nil, socklen_t.zero, NI_NUMERICHOST)
            
            return result == Int32.zero ? hostname : [CChar].init()
        }
        
        // IPv4 주소를 문자열 형태로 전달합니다.
        return String(cString: buffer, encoding: String.Encoding.utf8)
    }
    
    /**
        IPv6 주소를 가져오는 함수입니다.

        - NOTE: [IPv6](https://terms.naver.com/entry.naver?docId=2070757&cid=42346&categoryId=42346)
        - Version: `1.0.0`
        - Returns: `Optional<String>`
     */
    final func extractAddressIPv6(_ address: UnsafeMutablePointer<sockaddr>) -> Optional<String> {
        
        // inet_ntop 함수를 통하여 입력받은 네트워크 인터페이스의 IPv6 주소를 가져옵니다.
        let buffer = address.withMemoryRebound(to: sockaddr_in6.self, capacity: 1) { pointer in
            
            var addrBuf = Array<CChar>.init(repeating: CChar.zero, count: Int(INET6_ADDRSTRLEN))
            
            inet_ntop(AF_INET6, &pointer.pointee.sin6_addr, &addrBuf, socklen_t(INET6_ADDRSTRLEN))
            
            return addrBuf
        }
        
        // IPv6 주소를 문자열 형태로 전달합니다.
        return String(cString: buffer, encoding: String.Encoding.utf8)
    }
    
    /**
         네트워크 인터페이스의 Family 가져오는 함수입니다.

         - Version: `1.0.0`
         - Returns: `Optional<String>`
     */
    final func extractFamily(_ family: sa_family_t) -> SKFamily {
        
        switch Int32(family) {
        case AF_INET:
            return .ipv4
        case AF_INET6:
            return .ipv6
        default:
            return .other
        }
    }
    
    final func createInterface(ifa: ifaddrs) -> SKInterface {
        
        let ifaFlags = Int32(ifa.ifa_flags)
        
        let interfaceName = extractInterfaceName(ifa.ifa_name) ?? String.init()
        let interfaceFamily = extractFamily(ifa.ifa_addr.pointee.sa_family).toString
        
        // 현재 네트워크 인터페이스에서 넷마스크 (Netmask) 주소를 구합니다.
        let netmask = extractAddress(ifa.ifa_netmask)
        
        let ipAddress = extractAddress(ifa.ifa_addr)
        let macAddress = extractAddressMAC(interfaceName)
        let broadcastAddress = extractAddress(ifa.ifa_dstaddr)
        
        return SKInterface(ipAddress: ipAddress, macAddress: macAddress, broadcastAddress: broadcastAddress,
                           netmask: netmask,
                           interfaceName: interfaceName, interfaceFamily: interfaceFamily, ifaFlags: ifaFlags)
    }
}

// MARK: - Public Extension SKNetworkInterface
public extension SKNetworkInterface {
    
    func allInterfaces() -> Array<SKInterface> {
        
        var result: Array<SKInterface> = Array.init()
        
        var ifaddrs: UnsafeMutablePointer<ifaddrs>? = nil
        
        // 현제 기기에 대한 모든 Network Interface 정보를 가져옵니다.
        guard getifaddrs(&ifaddrs) == Int32.zero else {
            logger.error("[SKNetworkInterface] Could't obtain network interface through the getifaddrs.")
            return Array.init()
        }
        
        var pointer: UnsafeMutablePointer<ifaddrs>? = ifaddrs
        while pointer != nil {
            guard let ifa = pointer?.pointee.ifa_addr.pointee else { continue }
            
            // IPv4 또는 IPv6 형태의 인터페이스를 확인합니다.
            if pointer != nil {
                let result = createInterface(ifa: pointer!.pointee)
                print(result)
            }
            
            pointer = pointer?.pointee.ifa_next
        }
        
        freeifaddrs(ifaddrs)
        
        return result
    }
}
#endif
