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

import Dispatch
import Foundation

@objc public class SKDispatchTimer: NSObject, SKClass {
        
    // MARK: - Typealias
    public typealias SKDispatchTimerHandler = () -> Swift.Void
    
    // MARK: - Object Properties
    public static var label: String = "com.SystemKit.SKDispatchTimer"
    public static var identifier: String = "A42D0B47-D7B3-4A23-8F30-B3E51555471E"
    
    private var interval = TimeInterval.zero
    private let implementQueue = DispatchQueue(label: SKDispatchFile.label)
    private var state = SKDispatchTimerState.suspended
    private var handler: Optional<SKDispatchTimerHandler> = nil
    private lazy var timer: Optional<DispatchSourceTimer> = nil
    
    // MARK: - Initalize
    @objc public init(interval: TimeInterval, _ handler: SKDispatchTimerHandler? = nil) {
        super.init()
        
        self.handler = handler
        self.interval = interval
        
        self.timer = makeTimerSource()
    }
    
    // MARK: - Deinitalize
    deinit { deinitalize() }
}

// MARK: - Private Extension SKDispatchTimer
private extension SKDispatchTimer {
    
    final func makeTimerSource(flags: DispatchSource.TimerFlags = .strict) -> DispatchSourceTimer {
        
        let timer = DispatchSource.makeTimerSource(flags: flags, queue: self.implementQueue)
        timer.schedule(deadline: DispatchTime.now(), repeating: self.interval)
        timer.setEventHandler { self.handler?() }
        
        return timer
    }
    
    final func deinitalize() {
        
        self.timer?.setEventHandler(handler: nil)
        
        // if the DispatchSourceTimer state is Cancelled, the cancel will not be performed
        if self.timer?.isCancelled == false { self.timer?.cancel() }
        
        self.handler = nil
    }
    
    final func withLock(_ handler: SKDispatchTimerHandler) {

        self.implementQueue.sync { handler() }
    }
}

// MARK: - Public Extension SKDispatchTimer
public extension SKDispatchTimer {
    
    @objc final func resume() {

        withLock {

            // If the DispatchSourceTimer state is currently Resume, the Resume will not be performed
            if self.state == .resumed || self.state == .activated { return }

            self.state = .resumed
            self.timer?.resume()
        }
    }
    
    @objc final func suspend() {

        withLock {

            // If the DispatchSourceTimer state is currently Suspend, the Suspend will not be performed
            if self.state == .suspended { return }

            // Suspend the DispatchSourceTimer
            self.state = .suspended
            self.timer?.suspend()
        }
    }
    
    @objc final func reschedule(interval: TimeInterval, _ handler: SKDispatchTimerHandler? = nil) {

        withLock {

            // Rescheduling the DispatchSourceTimer's TimeInterval
            self.interval = interval
            self.timer?.schedule(deadline: DispatchTime.now(), repeating: self.interval)

            // Rescheduling the DispatchSourceTimer's EventHandler
            self.handler = handler
            self.timer?.setEventHandler { self.handler?() }
        }
    }
    
    @objc final func cancel() {

        withLock {

            // If the DispatchSourceTimer state is currently Cancel, the Cancel will not be performed
            if self.state == .canceled || self.timer?.isCancelled == true { return }

            // Cancel the DispatchSourceTimer
            self.state = .canceled
            self.timer?.cancel()
        }
    }
    
    @objc final func activate() {

        withLock {

            self.state = .activated
            self.timer?.activate()
        }
    }
}
