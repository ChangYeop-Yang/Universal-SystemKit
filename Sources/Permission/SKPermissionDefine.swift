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
import Foundation

// MARK: - Enum
public enum SKPermissionServiceName: String, CaseIterable {

    case All = "All"
    
    case AddressBook = "kTCCServiceAddressBook"
    case AppleEvents = "kTCCServiceAppleEvents"
    case Bluetooth = "kTCCServiceBluetoothAlways"
    case Calendar = "kTCCServiceCalendar"
    case Camera = "kTCCServiceCamera"
    case ContactsFull = "kTCCServiceContactsFull"
    case ContactsLimited = "kTCCServiceContactsLimited"
    case FileProviderDomain = "kTCCServiceFileProviderDomain"
    case FileProviderPresence = "kTCCServiceFileProviderPresence"
    case Location = "kTCCServiceLocation"
    case MediaLibrary = "kTCCServiceMediaLibrary"
    case Microphone = "kTCCServiceMicrophone"
    case Motion = "kTCCServiceMotion"
    case Photos = "kTCCServicePhotos"
    case PhotosAdd = "kTCCServicePhotosAdd"
    case Prototype3Rights = "kTCCServicePrototype3Rights"
    case Prototype4Rights = "kTCCServicePrototype4Rights"
    case Reminders = "kTCCServiceReminders"
    case ScreenCapture = "kTCCServiceScreenCapture"
    case Siri = "kTCCServiceSiri"
    case SpeechRecognition = "kTCCServiceSpeechRecognition"
    case Willow = "kTCCServiceWillow"
    case Accessibility = "kTCCServiceAccessibility"
    case PostEvent = "kTCCServicePostEvent"
    case ListenEvent = "kTCCServiceListenEvent"
    case DeveloperTool = "kTCCServiceDeveloperTool"
    case HomeKit = "kTCCServiceHomeKit"
    case SocialService = "kTCCServiceSocial"
    case TVProvider = "kTCCServiceTVProvider"
    
    /* These seem to be carry-overs from macOS */
    case SystemPolicyFullDiskAccess = "kTCCServiceSystemPolicyAllFiles"
    case SystemPolicyDeveloperFiles = "kTCCServiceSystemPolicyDeveloperFiles"
    case SystemPolicyRemovableVolumes = "kTCCServiceSystemPolicyRemovableVolumes"
    case SystemPolicyNetworkVolumes = "kTCCServiceSystemPolicyNetworkVolumes"
    case SystemPolicyDesktopFolder = "kTCCServiceSystemPolicyDesktopFolder"
    case SystemPolicyDownloadsFolder = "kTCCServiceSystemPolicyDownloadsFolder"
    case SystemPolicyDocumentsFolder = "kTCCServiceSystemPolicyDocumentsFolder"
    case SystemPolicySysAdminFiles = "kTCCServiceSystemPolicySysAdminFiles"
    
    /* These seem to be carry-overs from iOS */
    case LiverPool = "kTCCServiceLiverpool"
    case Ubiquity = "kTCCServiceUbiquity"
    case ShareKit = "kTCCServiceShareKit"
    case LinkedIn = "kTCCServiceLinkedIn"
    case Twitter = "kTCCServiceTwitter"
    case FaceBook = "kTCCServiceFacebook"
    case SinaWeibo = "kTCCServiceSinaWeibo"
    case TencentWeibo = "kTCCServiceTencentWeibo"
    
    // MARK: Enum Computed Properties
    public var name: String { self.rawValue }
}
#endif
