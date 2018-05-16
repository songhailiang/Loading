//
//  Timer.swift
//  Loading
//
//  Created by songhailiang on 2018/5/15.
//  Copyright © 2018 songhailiang. All rights reserved.
//

import Foundation

extension Timer {

    /// Create and start a timer that will call `then` once after the specified time.
    ///
    /// - Parameters:
    ///   - interval: specified time
    ///   - mode: RunLoopMode that the timer runs in
    ///   - then: handle that will be called when timer fired
    /// - Returns: the timer object
    @discardableResult
    public class func after(_ interval: TimeInterval, mode: RunLoopMode = .defaultRunLoopMode, _ then: @escaping () -> Void) -> Timer {
        let timer = Timer.new(after: interval, then)
        timer.start(modes: mode)
        return timer
    }

    /// Create and start a timer that will call `then` repeatedly in the specified time intervals.
    ///
    /// - Parameters:
    ///   - interval: specified time interval
    ///   - mode: RunLoopMode that the timer runs in
    ///   - then: handle that will be called when timer fired
    /// - Returns: the timer object
    @discardableResult
    public class func every(_ interval: TimeInterval, mode: RunLoopMode = .defaultRunLoopMode, _ then: @escaping () -> Void) -> Timer {
        let timer = Timer.new(every: interval, then)
        timer.start(modes: mode)
        return timer
    }

    /// Create and start a timer that will call `then` repeatedly in the specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Parameters:
    ///   - interval: specified time interval
    ///   - mode: RunLoopMode that the timer runs in
    ///   - then: handle that will be called when timer fired
    /// - Returns: the timer object
    @nonobjc @discardableResult
    public class func every(_ interval: TimeInterval, mode: RunLoopMode = .defaultRunLoopMode, _ then: @escaping (Timer) -> Void) -> Timer {
        let timer = Timer.new(every: interval, then)
        timer.start(modes: mode)
        return timer
    }

    /// Create a timer that will call `then` once after the specified time.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.after` to create and schedule a timer in one step.
    public class func new(after interval: TimeInterval, _ then: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, 0, 0, 0) { _ in
            then()
        }
    }

    /// Create a timer that will call `then` repeatedly in specified time intervals.
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    public class func new(every interval: TimeInterval, _ then: @escaping () -> Void) -> Timer {
        return CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            then()
        }
    }

    /// Create a timer that will call `then` repeatedly in specified time intervals.
    /// (This variant also passes the timer instance to the block)
    ///
    /// - Note: The timer won't fire until it's scheduled on the run loop.
    ///         Use `NSTimer.every` to create and schedule a timer in one step.
    @nonobjc public class func new(every interval: TimeInterval, _ then: @escaping (Timer) -> Void) -> Timer {
        var timer: Timer!
        timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, interval, 0, 0) { _ in
            then(timer)
        }
        return timer
    }

    // MARK: Manual scheduling

    /// Schedule this timer on the run loop
    ///
    /// By default, the timer is scheduled on the current run loop for the default mode.
    /// Specify `runLoop` or `modes` to override these defaults.
    public func start(runLoop: RunLoop = .current, modes: RunLoopMode...) {
        let modes = modes.isEmpty ? [.defaultRunLoopMode] : modes

        for mode in modes {
            runLoop.add(self, forMode: mode)
        }
    }
}
