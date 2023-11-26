//
//  TrophyNotificationPresenter.swift
//

import Foundation
import UIKit

final class TrophyNotificationPresenter {

  private let rootView: UIView
  private let consumeNextMessage: () -> TrophySocketResponse?
  private let hideDebouncer: Debouncer

  private let notificationView = TrophyNotificationView()
  private weak var topPinConstraint: NSLayoutConstraint?

  init(
    rootView: UIView,
    consumeNextMessage: @escaping () -> TrophySocketResponse?,
    onMessageReceive: ObservableEvent,
    hideDebouncer: Debouncer
  ) {

    self.rootView = rootView
    self.consumeNextMessage = consumeNextMessage
    self.hideDebouncer = hideDebouncer

    onMessageReceive.subscribe {
      self.showNotificationIfNeeded()
    }
  }
}

// MARK: - Private

extension TrophyNotificationPresenter {

  func showNotificationIfNeeded() {
    if let message = consumeNextMessage() {
      showNotification(message)
    }
  }

  func showNotification(_ message: TrophySocketResponse) {
    if !isNotificationUIShown {
      showNotificationUI(over: rootView)
    }

    notificationView
      .update(message: message)
      .onTap { [weak self] in
        self?.hideNotificationUI()
      }

    hideDebouncer.debounce { [weak self] in
      self?.hideIfNeeded()
    }
  }

  func hideIfNeeded() {
    if isNotificationUIShown {
      hideNotificationUI()
    }
  }

  var isNotificationUIShown: Bool {
    notificationView.superview != nil
  }

  private func showNotificationUI(over view: UIView) {
    view.addSubview(notificationView)
    view.bringSubviewToFront(notificationView)

    notificationView.translatesAutoresizingMaskIntoConstraints = false

    let topConstraint = notificationView.topAnchor
      .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -100)

    self.topPinConstraint = topConstraint

    NSLayoutConstraint.activate([
      topConstraint,
      notificationView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
      notificationView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8)
    ])

    topPinConstraint?.constant = 0

    UIView.transition(
      with: notificationView,
      duration: 0.3,
      options: .transitionCrossDissolve,
      animations: {
        self.notificationView.superview?.layoutIfNeeded()
      })
  }

  private func hideNotificationUI() {
    topPinConstraint?.constant = -100

    UIView.transition(
      with: notificationView,
      duration: 0.3,
      options: .transitionCrossDissolve,
      animations: {
        self.notificationView.superview?.layoutIfNeeded()
      },
      completion: { _ in
        self.notificationView.removeFromSuperview()
      })
  }
}
