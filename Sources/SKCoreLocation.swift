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

import Foundation
import CoreLocation

public class SKCoreLocation: NSObject, SKClass {
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKCoreLocation"
    public static var identifier: String = "4234796A-D9FC-423E-A902-21F1647F2B92"
    
    public let manager: CLLocationManager = CLLocationManager()
    public private(set) var delegate: Optional<CLLocationManagerDelegate> = nil
    public var recentlyLocation: Optional<CLLocation> { return self.manager.location }
    
    // MARK: - Initalize
    public init(delegate: Optional<CLLocationManagerDelegate> = nil) {
        self.delegate = delegate
    }
}

// MARK: - Public Extension SKCoreLocation
public extension SKCoreLocation {
    
    @available(macOS 10.15, iOS 8.0, *)
    final func requestAuthorization(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        
        NSLog("[%@][%@] Initalize, SKCoreLocation", SKCoreLocation.label, SKCoreLocation.identifier)
        
        self.manager.delegate = self.delegate
        self.manager.desiredAccuracy = desiredAccuracy
        
        self.manager.requestAlwaysAuthorization()
        self.manager.startUpdatingLocation()
    }
}

#if os(macOS)
import AppKit

// MARK: - Public Extension SKCoreLocation With macOS Platform
public extension SKCoreLocation {
    
    @discardableResult
    final func openPrivacyLocationServicePref() -> Bool {
        
        let rawValue: String = SKSecurityPrivacyPreferencePane.PrivacyLocationServices.rawValue
        
        guard let url: URL = URL(string: rawValue) else { return false }
        
        return NSWorkspace.shared.open(url)
    }
    
    @available(macOS 10.7, *)
    final func isLocationServicesEnabled() -> Bool {
        
        let locationServicesEnabled: Bool = CLLocationManager.locationServicesEnabled()
        
        return locationServicesEnabled
    }
    
    typealias AuthorizationStatusResult = (status: CLAuthorizationStatus, isPermission: Bool)
    @available(macOS 11.0, *)
    final func getAuthorizationStatus() -> AuthorizationStatusResult {
        
        switch self.manager.authorizationStatus {
        // The user has not chosen whether the app can use location services.
        case CLAuthorizationStatus.notDetermined:
            NSLog("[%@][%@] Location Permission: NotDetermined", SKCoreLocation.label, SKCoreLocation.identifier)
            return (CLAuthorizationStatus.notDetermined, true)
        
        // The app is not authorized to use location services.
        case CLAuthorizationStatus.restricted:
            NSLog("[%@][%@] Location Permission: Restricted", SKCoreLocation.label, SKCoreLocation.identifier)
            return (CLAuthorizationStatus.restricted, false)
        
        // The user denied the use of location services for the app or they are disabled globally in Settings.
        case CLAuthorizationStatus.denied:
            NSLog("[%@][%@] Location Permission: Denied", SKCoreLocation.label, SKCoreLocation.identifier)
            return (CLAuthorizationStatus.denied, false)
        
        // The user authorized the app to start location services at any time.
        case CLAuthorizationStatus.authorizedAlways:
            NSLog("[%@][%@] Location Permission: AuthorizedAlways", SKCoreLocation.label, SKCoreLocation.identifier)
            return (CLAuthorizationStatus.authorizedAlways, true)
        
        // The user authorized the app to start location services at any time.
        case CLAuthorizationStatus.authorized:
            NSLog("[%@][%@] Location Permission: Authorized", SKCoreLocation.label, SKCoreLocation.identifier)
            return (CLAuthorizationStatus.authorized, true)
            
        @unknown default:
            fatalError("Invaild, CLAuthorizationStatus")
        }
    }
}
#endif
