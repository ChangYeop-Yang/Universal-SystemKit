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

#if os(macOS)
import Cocoa
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
    case LiverPool = "kTCCServiceLiverpool"
    case Ubiquity = "kTCCServiceUbiquity"
    case LinkedIn = "kTCCServiceLinkedIn"
    case Twitter = "kTCCServiceTwitter"
    case FaceBook = "kTCCServiceFacebook"
    case SinaWeibo = "kTCCServiceSinaWeibo"
    case TencentWeibo = "kTCCServiceTencentWeibo"
    case FullDiskAccess = "kTCCServiceSystemPolicyAllFiles"
    case SystemPolicyDeveloperFiles = "kTCCServiceSystemPolicyDeveloperFiles"
    case SystemPolicyRemovableVolumes = "kTCCServiceSystemPolicyRemovableVolumes"
    case SystemPolicyNetworkVolumes = "kTCCServiceSystemPolicyNetworkVolumes"
    case SystemPolicyDesktopFolder = "kTCCServiceSystemPolicyDesktopFolder"
    case SystemPolicyDownloadsFolder = "kTCCServiceSystemPolicyDownloadsFolder"
    case SystemPolicyDocumentsFolder = "kTCCServiceSystemPolicyDocumentsFolder"
    case SystemPolicySysAdminFiles = "kTCCServiceSystemPolicySysAdminFiles"
    
    // MARK: Enum Computed Properties
    public var name: String { self.rawValue }
}

public enum SKDefaultPreferencePane: String, CaseIterable {
    
    case Battery = "x-apple.systempreferences:com.apple.preference.battery"
    case Password = "x-apple.systempreferences:com.apple.preferences.password"
    case Notifications = "x-apple.systempreferences:com.apple.preference.notifications"
    case SoftwareUpdate = "x-apple.systempreferences:com.apple.preferences.softwareupdate?client=softwareupdateapp"
    case FamilySharingPrefPane = "x-apple.systempreferences:com.apple.preferences.FamilySharingPrefPane"
    case AppleID = "x-apple.systempreferences:com.apple.preferences.AppleIDPrefPane"
    case Wallet = "x-apple.systempreferences:com.apple.preferences.wallet"
    case Profile = "x-apple.systempreferences:com.apple.preferences.configurationprofiles"
    case Screentime = "x-apple.systempreferences:com.apple.preference.screentime"
    
    // MARK: macOS Ventura (Version 13.*)
    case LoginItems = "x-apple.systempreferences:com.apple.LoginItems-Settings.extension"
    case DesktopScreenEffect = "x-apple.systempreferences:com.apple.preference.desktopscreeneffect"
}

public enum SKAccessibilityPreferencePane: String, CaseIterable  {

    case Display = "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Display"
    case Zoom = "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_Zoom"
    case VoiceOver = "x-apple.systempreferences:com.apple.preference.universalaccess?Seeing_VoiceOver"
    case Descriptions = "x-apple.systempreferences:com.apple.preference.universalaccess?Media_Descriptions"
    case Captions = "x-apple.systempreferences:com.apple.preference.universalaccess?Captioning"
    case Audio = "x-apple.systempreferences:com.apple.preference.universalaccess?Hearing"
    case Keyboard = "x-apple.systempreferences:com.apple.preference.universalaccess?Keyboard"
    case Mouse = "x-apple.systempreferences:com.apple.preference.universalaccess?Mouse"
    case Switch = "x-apple.systempreferences:com.apple.preference.universalaccess?Switch"
    case Dictation = "x-apple.systempreferences:com.apple.preference.universalaccess?SpeakableItems"
}

public enum SKSharingPreferencePane: String, CaseIterable {
    
    case Main = "x-apple.systempreferences:com.apple.preferences.sharing"
    case ShareScreen = "x-apple.systempreferences:com.apple.preferences.sharing?Services_ScreenSharing"
    case SharePrint = "x-apple.systempreferences:com.apple.preferences.sharing?Services_PrinterSharing"
    case ShareFile = "x-apple.systempreferences:com.apple.preferences.sharing?Services_PersonalFileSharing"
    case RemoteLogin = "x-apple.systempreferences:com.apple.preferences.sharing?Services_RemoteLogin"
    case RemoteAppleEvents = "x-apple.systempreferences:com.apple.preferences.sharing?Services_RemoteAppleEvent"
    case RemoteManagement = "x-apple.systempreferences:com.apple.preferences.sharing?Services_ARDService"
    case ShareInternet = "x-apple.systempreferences:com.apple.preferences.sharing?Internet"
    case ShareBluetooth = "x-apple.systempreferences:com.apple.preferences.sharing?Services_BluetoothSharing"
}

public enum SKDictationSpeechPreferencePane: String, CaseIterable {
    
    case Dictation = "x-apple.systempreferences:com.apple.preference.speech?Dictation"
    case TextToSpeech = "x-apple.systempreferences:com.apple.preference.speech?TTS"
}

public enum SKSecurityPrivacyPreferencePane: String, CaseIterable {
    
    case Main = "x-apple.systempreferences:com.apple.preference.security"
    case General = "x-apple.systempreferences:com.apple.preference.security?General"
    case FileVault = "x-apple.systempreferences:com.apple.preference.security?FDE"
    case Firewall = "x-apple.systempreferences:com.apple.preference.security?Firewall"
    case Advanced = "x-apple.systempreferences:com.apple.preference.security?Advanced"
    case Privacy = "x-apple.systempreferences:com.apple.preference.security?Privacy"
    case PrivacyAccessibility = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    case PrivacyAssistive = "x-apple.systempreferences:com.apple.preference.security?Privacy_Assistive"
    case PrivacyLocationServices = "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
    case PrivacyContacts = "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"
    case PrivacyDiagnosticsUsage = "x-apple.systempreferences:com.apple.preference.security?Privacy_Diagnostics"
    case PrivacyCalendars = "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
    case PrivacyReminders = "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
    case PrivacyTencentWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_TencentWeibo"
    case PrivacyAutomation = "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation"
    case PrivacyAdvertising = "x-apple.systempreferences:com.apple.preference.security?Privacy_Advertising"
    
    case PrivacyFacebook = "x-apple.systempreferences:com.apple.preference.security?Privacy_Facebook"
    case PrivacyLinkedIn = "x-apple.systempreferences:com.apple.preference.security?Privacy_LinkedIn"
    case PrivacyTwitter = "x-apple.systempreferences:com.apple.preference.security?Privacy_Twitter"
    case PrivacyWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_Weibo"
    
    case PrivacyFullDiskAccess = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
    
    // MARK: macOS Catalina (Version: 10.15)
    case PrivacyDevTools = "x-apple.systempreferences:com.apple.preference.security?Privacy_DevTools"
    case PrivacyDesktopFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DesktopFolder"
    case PrivacyDocumentsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DocumentsFolder"
    case PrivacyDownloadsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DownloadsFolder"
    case PrivacyNetworkVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_NetworkVolume"
    case PrivacyRemovableVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_RemovableVolume"
    case PrivacyInputMonitoring = "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent"
    case PrivacyScreenCapture = "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
}

#endif
