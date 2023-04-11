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
import Dispatch
import Foundation

@objc public class SKDispatchFile: NSObject, SKClass {
    
    // MARK: - Typealias
    public typealias FileIOReadCompletion = (Data, Int32) -> Swift.Void
    public typealias FileIOWriteCompletion = (Int32) -> Swift.Void
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKDispatchFile"
    public static var identifier: String = "870EBBA7-3167-4147-BE3A-82E0C4A108A2"
    
    private let mode: mode_t
    private let implementQueue: DispatchQueue
    
    // MARK: - Initalize
    public init(qualityOfService qos: DispatchQoS = .default, mode: mode_t = 0o777) {
        self.mode = mode
        self.implementQueue = DispatchQueue(label: SKDispatchFile.label, qos: qos, attributes: .concurrent)
    }
}

// MARK: - Private Extension SKDispatchFile
private extension SKDispatchFile {
    
    static func closeChannel(channel: DispatchIO, filePath: String, error: Int32) {

        let result: Int32 = flock(channel.fileDescriptor, LOCK_UN)
        logger.info("[SKDispatchFile][\(filePath)][error: \(result)] Unlock FileDescriptor")
        
        channel.close(flags: DispatchIO.CloseFlags.stop)
        logger.info("[SKDispatchFile][\(filePath)][error: \(error)] Close DispatchIO Operation")
    }
    
    final func createFileChannel(filePath: String, _ oflag: Int32) -> Optional<DispatchIO> {
        
        let fileDescriptor = open(filePath, oflag, self.mode)
        
        if fileDescriptor == EOF {
            logger.error("[SKDispatchFile][\(filePath)] Could't create file descriptor")
            return nil
        }
        
        // 파일 작업을 수행하기 전에 다른 프로세스 및 쓰레드에 대하여 원자성을 보장하기 위하여 파일 잠금을 수행합니다.
        flock(fileDescriptor, LOCK_EX)

        let channel = DispatchIO(type: .stream, fileDescriptor: fileDescriptor, queue: self.implementQueue) { error in
            
            // The handler to execute once the channel is closed.
            logger.info("[SKDispatchFile][\(filePath)][error: \(error)] DispatchIO Cleanup")
        }
        
        return channel
    }
}

// MARK: - Public Extension SKDispatchFile
public extension SKDispatchFile {
    
    /**
        파일에 대하여 쓰기 작업을 수행합니다.
        Perform a write operation on the file.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - NOTE: `스레드 안전 (Thread Safety)`
        - Parameters:
            - contents: 파일에 쓰기 작업을 수행하기 위한 `Data`를 입력받는 매개변수
            - filePath: 쓰기 작업을 수행 할 파일 경로를 입력받는 매개변수
            - completion: 쓰기 작업을 통한 `(Int32) -> Swift.Void` 형태의 결과물을 전달하는 매개변수
     */
    final func write(contents: Data, filePath: String, _ completion: @escaping FileIOWriteCompletion) {
            
        // 쓰기 작업을 수행하기 위한 DispatchIO 생성합니다.
        guard let channel = self.createFileChannel(filePath: filePath, O_WRONLY | O_CREAT) else { return }
        
        let body: (UnsafeRawBufferPointer) throws -> Swift.Void = { pointer in
            
            // If the baseAddress of this buffer is nil, the count is zero.
            guard let baseAddress = pointer.baseAddress else {
                SKDispatchFile.closeChannel(channel: channel, filePath: filePath, error: EOF)
                return
            }
            
            let bytes = UnsafeRawBufferPointer(start: baseAddress, count: contents.count)
            
            let data = DispatchData(bytes: bytes)
            
            channel.write(offset: off_t.zero, data: data, queue: self.implementQueue) { done, data, error in
            
                // 파일 쓰기 작업에 오류가 발생한 경우에는 읽기 작업을 종료합니다.
                guard error == Int32.zero else {
                    SKDispatchFile.closeChannel(channel: channel, filePath: filePath, error: error)
                    return
                }
                
                // 정상적으로 파일 쓰기 작업이 완료 된 경우에 파일 내용을 전달합니다.
                if done {
                    // 쓰기 작업에 수행 한 모든 파일 내용을 전달합니다.
                    completion(error)
                    
                    // 파일 쓰기 작업을 위해서 생성 한 DispatchIO을 닫습니다.
                    SKDispatchFile.closeChannel(channel: channel, filePath: filePath, error: error)
                }
            }
        }
        
        do { try contents.withUnsafeBytes(body) }
        catch let error as NSError {
            let errcode: Int32 = Int32(error.code)
            SKDispatchFile.closeChannel(channel: channel, filePath: filePath, error: errcode)
            return
        }
    }
    
    /**
        파일에 대하여 읽기 작업을 수행합니다.
        Perform a read operation on the file.

        - Version: `1.0.0`
        - Authors: `ChangYeop-Yang`
        - NOTE: `스레드 안전 (Thread Safety)`
        - Parameters:
            - filePath: 읽기 작업을 수행하는 파일 경로를 입력받는 매개변수
            - completion: 읽기 작업을 통한 `(Data, Int32) -> Swift.Void` 형태의 결과물을 전달하는 매개변수
     */
    final func read(filePath: String, _ completion: @escaping FileIOReadCompletion) {
    
        // 파일 읽기 작업을 수행하기 전에 해당 파일이 실제로 존재하는지 확인합니다.
        guard FileManager.default.fileExists(atPath: filePath) else {
            logger.error("[SKDispatchFile][\(filePath)] The file does not exist at the specified path")
            return
        }
    
        // 읽기 작업을 수행하기 위한 DispatchIO 생성합니다.
        guard let channel = createFileChannel(filePath: filePath, O_RDONLY) else { return }
        
        var rawData = Data()
                
        channel.read(offset: off_t.zero, length: Int.max, queue: self.implementQueue) { done, data, error in
            
            // 파일 읽기 작업에 오류가 발생한 경우에는 읽기 작업을 종료합니다.
            guard error == Int32.zero else {
                SKDispatchFile.closeChannel(channel: channel, filePath: filePath, error: error)
                return
            }
            
            // 정상적으로 파일로부터 데이터를 읽어들이는 경우
            if let contentsOf = data { rawData.append(contentsOf: contentsOf) }
            
            // 정상적으로 파일 읽기 작업이 완료 된 경우에 파일 내용을 전달합니다.
            if done {
                // 읽어들인 모든 파일 내용을 전달합니다.
                completion(rawData, error)
                
                // 파일 읽기 작업을 위해서 생성 한 DispatchIO을 닫습니다.
                SKDispatchFile.closeChannel(channel: channel, filePath: filePath, error: error)
            }
        }
    }
}
#endif
