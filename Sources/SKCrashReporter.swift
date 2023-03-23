///*
// * Copyright (c) 2022 Universal-SystemKit. All rights reserved.
// *
// * Permission is hereby granted, free of charge, to any person obtaining a copy
// * of this software and associated documentation files (the "Software"), to deal
// * in the Software without restriction, including without limitation the rights
// * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// * copies of the Software, and to permit persons to whom the Software is
// * furnished to do so, subject to the following conditions:
// *
// * The above copyright notice and this permission notice shall be included in
// * all copies or substantial portions of the Software.
// *
// * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// * THE SOFTWARE.
// */
//
//// swiftlint:disable all
//#if os(iOS) || os(macOS)
//import Foundation
//
//import CrashReporter
//
//public class SKCrashReporter: SKClass {
//    
//    // MARK: - Object Properties
//    public static var label: String = "com.SystemKit.SKCrashReporter"
//    public static var identifier: String = "4552D8B1-1522-4EB0-B02F-95DFC9598169"
//
//    public var crashReporter: Optional<PLCrashReporter> = nil
//    private var signalHandlerType: PLCrashReporterSignalHandlerType {
//
//        // 현재 장비의 운영체제 환경에 적합한 PLCrashReporterSignalHandlerType을 설정합니다.
//        #if os(iOS)
//            return PLCrashReporterSignalHandlerType.mach
//        #elseif os(macOS)
//            return PLCrashReporterSignalHandlerType.BSD
//        #endif
//    }
//    private let crashReportFileName: String
//    private let crashReportDirectory: String
//    
//    // MARK: - Initalize
//    public init(crashReportDirectory: String, crashReportFileName: String) {
//        
//        self.crashReportFileName = crashReportFileName
//        self.crashReportDirectory = crashReportDirectory
//    }
//}
//
//// MARK: - Private Extension SKCrashReporter
//private extension SKCrashReporter {
//    
//    final func getCrashReportData() -> Data {
//        
//        // CrashReportData 가져오기 위해서 PLCrashReporter 인스턴스 생성 여부를 확인합니다.
//        guard let reporter = self.crashReporter else { return Data.init() }
//        
//        do {
//            #if DEBUG
//                NSLog("[%@][%@] Action, PLCrashReporter loadPendingCrashReportData", Self.label, Self.identifier)
//                return reporter.loadPendingCrashReportData()
//            #else
//                NSLog("[%@][%@] Action, PLCrashReporter loadPendingCrashReportDataAndReturnError", Self.label, Self.identifier)
//                return try reporter.loadPendingCrashReportDataAndReturnError()
//            #endif
//        } catch let error as NSError {
//            NSLog("[%@][%@] Error, %@", Self.label, Self.identifier, error.description)
//            return Data.init()
//        }
//    }
//    
//    @discardableResult
//    final func save() -> Bool {
//                
//        // 사용자에게 입력받은 경로에 폴더가 존재하지 않는 경우에는 종료합니다.
//        guard FileManager.default.fileExists(atPath: self.crashReportDirectory) else { return false }
//                
//        // PLCrashReporter를 통하여 PLCrashReport 생성에 필요로하는 Data를 생성합니다.
//        let rawValue: Data = getCrashReportData()
//        
//        // PLCrashReport 내용이 존재하지 않는 경우에는 함수를 종료합니다.
//        if rawValue.isEmpty {
//            NSLog("[%@][%@] Error, Could't Load PLCrashReport Data", Self.label, Self.identifier)
//            return false
//        }
//
//        self.crashReporter?.purgePendingCrashReport()
//
//        let fileURLWithPath = String(format: "%@/%@.plcrash", self.crashReportDirectory, self.crashReportFileName)
//        let toURL = URL(fileURLWithPath: fileURLWithPath, isDirectory: false)
//
//        do {
//            try rawValue.write(to: toURL)
//            return FileManager.default.isWritableFile(atPath: toURL.path)
//        } catch let error as NSError {
//            NSLog("[%@][%@] Error, %@", Self.label, Self.identifier, error.description)
//            return false
//        }
//    }
//}
//
//// MARK: - Public Extension SKCrashReporter
//public extension SKCrashReporter {
//
//    /**
//        `PLCrashReport` 및 `PLCrashReport` 내용을 `String` 값의 형태로 가져옵니다.
//
//        - Version: `1.0.0`
//        - NOTE: [PLCrashReporter - GitHub](https://github.com/microsoft/plcrashreporter)
//        - Authors: `ChangYeop-Yang`
//        - Returns: `Optional<SKCrashReportResult>`
//    */
//    typealias SKCrashReportResult = (report: PLCrashReport, contents: String)
//    final func getCrashReport() throws -> Optional<SKCrashReportResult> {
//
//        let rawValue: Data = getCrashReportData()
//
//        let crashReport: PLCrashReport = try PLCrashReport(data: rawValue)
//
//        guard let result = PLCrashReportTextFormatter.stringValue(for: crashReport,
//                                                                  with: PLCrashReportTextFormatiOS) else {
//            NSLog("[%@][%@] Error, Could't Read PLCrashReport Contents", Self.label, Self.identifier)
//            return nil
//        }
//
//        return SKCrashReportResult(crashReport, result)
//    }
//
//    /**
//        `PLCrashReporter` 객체를 생성하고 Application에 대한 Crash Event Handling 작업을 활성화합니다.
//
//        - Version: `1.0.0`
//        - NOTE: [PLCrashReporter - GitHub](https://github.com/microsoft/plcrashreporter)
//        - Authors: `ChangYeop-Yang`
//    */
//    final func enable(handleSignal: @escaping PLCrashReporterPostCrashSignalCallback) throws {
//
//        let symbolicationStrategy = PLCrashReporterSymbolicationStrategy.all
//        let configuration = PLCrashReporterConfig(signalHandlerType: self.signalHandlerType,
//                                                  symbolicationStrategy: symbolicationStrategy)
//
//        guard let reporter = PLCrashReporter(configuration: configuration) else {
//            NSLog("[%@][%@] Error, Could't Create an instance of PLCrashReporter", Self.label, Self.identifier)
//            return
//        }
//
//        var callback = PLCrashReporterCallbacks(version: UInt16.zero, context: nil, handleSignal: handleSignal)
//        reporter.setCrash(&callback)
//
//        #if DEBUG
//            NSLog("[%@][%@] Action, PLCrashReporter enable", Self.label, Self.identifier)
//            reporter.enable()
//        #else
//            NSLog("[%@][%@] Action, PLCrashReporter enableAndReturnError", Self.label, Self.identifier)
//            try reporter.enableAndReturnError()
//        #endif
//
//        self.crashReporter = reporter
//        
//        // 이전의 애플리케이션에서 CrashReport가 생성되었는지를 확인합니다.
//        if reporter.hasPendingCrashReport() {
//            NSLog("[%@][%@] Action, Save PLCrashReporter", Self.label, Self.identifier)
//            self.save()
//        }
//    }
//
//    /**
//        `PLCrashReporter` 객체를 소멸합니다.
//
//        - Version: `1.0.0`
//        - NOTE: [PLCrashReporter - GitHub](https://github.com/microsoft/plcrashreporter)
//        - Authors: `ChangYeop-Yang`
//     */
//    final func disable() throws {
//
//        // 현재 PLCrashReporter 객체가 nil인 경우에는 초기화 작업을 수행하지 않습니다.
//        if self.crashReporter == nil { return }
//
//        #if DEBUG
//            self.crashReporter?.purgePendingCrashReport()
//            NSLog("[%@][%@] Action, PLCrashReporter purgePendingCrashReport", Self.label, Self.identifier)
//        #else
//            try self.crashReporter?.purgePendingCrashReportAndReturnError()
//            NSLog("[%@][%@] Action, PLCrashReporter purgePendingCrashReportAndReturnError", Self.label, Self.identifier)
//        #endif
//
//        self.crashReporter = nil
//    }
//}
//#endif
