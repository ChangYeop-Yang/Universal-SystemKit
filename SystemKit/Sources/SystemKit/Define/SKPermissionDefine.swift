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
public enum SKPermissionServiceName: String {
    
    case remoteLogin = ""
    case fullDiskAccess = "kTCCServiceSystemPolicyAllFiles"
}

public enum SKSharingPreferencePane: String {
    
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

public enum SKDictationSpeechPreferencePane: String {
    
    case Dictation = "x-apple.systempreferences:com.apple.preference.speech?Dictation"
    case TextToSpeech = "x-apple.systempreferences:com.apple.preference.speech?TTS"
}

public enum SKSecurityPrivacyPreferencePane: String {
    
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
    case PrivacyFacebook = "x-apple.systempreferences:com.apple.preference.security?Privacy_Facebook"
    case PrivacyLinkedIn = "x-apple.systempreferences:com.apple.preference.security?Privacy_LinkedIn"
    case PrivacyTwitter = "x-apple.systempreferences:com.apple.preference.security?Privacy_Twitter"
    case PrivacyWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_Weibo"
    case PrivacyTencentWeibo = "x-apple.systempreferences:com.apple.preference.security?Privacy_TencentWeibo"
    case PrivacyFullDiskAccess = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
    case PrivacyDesktopFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DesktopFolder"
    case PrivacyDocumentsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DocumentsFolder"
    case PrivacyDownloadsFolder = "x-apple.systempreferences:com.apple.preference.security?Privacy_DownloadsFolder"
    case PrivacyNetworkVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_NetworkVolume"
    case PrivacyRemovableVolume = "x-apple.systempreferences:com.apple.preference.security?Privacy_RemovableVolume"
}

#endif
