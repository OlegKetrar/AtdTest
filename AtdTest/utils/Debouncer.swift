//
//  Debouncer.swift
//

import Foundation
import Dispatch

public final class Debouncer {
    private let interval: DispatchTimeInterval
    private let queue: DispatchQueue

    private let lock = NSRecursiveLock()
    private var lastFireTime: DispatchTime = .now()

    public init(interval: DispatchTimeInterval, queue: DispatchQueue = .main) {
        self.interval = interval
        self.queue = queue
    }

    public func debounce(_ closure: @escaping () -> Void) {
        lock.sync {
            lastFireTime = .now()
        }

        queue.asyncAfter(deadline: .now() + interval, execute: { [weak self] in
            guard let strongSelf = self else { return }

            let now = DispatchTime.now()
            let lastFireTime = strongSelf.lock.sync { strongSelf.lastFireTime }
            let when = lastFireTime + strongSelf.interval

            if now >= when {
                closure()
            }
        })
    }
}

private extension NSRecursiveLock {

    func sync<T>(_ critical: () -> T) -> T {
        lock()
        let result = critical()
        unlock()

        return result
    }
}
