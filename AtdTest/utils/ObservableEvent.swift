//
//  ObservableEvent.swift
//

public class ObservableEvent {
  private var subscribers: [() -> Void] = []

    public init() {}

    @discardableResult
    public func subscribe(_ callback: @escaping () -> Void) -> Self {
      subscribers.append(callback)
        return self
    }

    public func send() {
      subscribers.forEach { $0() }
    }
}
