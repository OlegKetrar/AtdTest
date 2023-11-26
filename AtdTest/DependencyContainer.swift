//
//  DependencyContainer.swift
//

import Foundation
import UIKit

final class DependencyContainer {
  private init() {}

  private static let trophyEvent = ObservableEvent()
  private static let trophyPresenter = makeTrophyNotificationPresenter()
  private static let fakeTrophyConnector = FakeTrophyConnector()

  static func initialise() {
    _ = trophyPresenter
  }

  static func makeMainViewController() -> UIViewController {
    let vc = MainViewController()
    vc.onButtonTap = {
      fakeTrophyConnector.mockEventReceived()
    }

    return vc
  }

  static func makeTrophyNotificationPresenter() -> TrophyNotificationPresenter {
    let storage = makeTrophyStorage()

    return TrophyNotificationPresenter(
      rootView: AppDelegate.shared.window ?? UIWindow(),
      consumeNextMessage: { storage.getLastMessageOnce() },
      onMessageReceive: trophyEvent,
      hideDebouncer: Debouncer(interval: .seconds(2)))
  }

  static func makeTrophyStorage() -> TrophyStorage {
    TrophyStorage(
        onMessageReceive: trophyEvent,
        socketConnector: fakeTrophyConnector,
        onDidBecomeActive: { callback in
          NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main,
            using: { _ in callback() })
        },
        onWillResignActive: { callback in
          NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main,
            using: { _ in callback() })
        })
  }
}
