//
//  TrophyStorage.swift
//

import Foundation

protocol TrophySocketConnectorProtocol: AnyObject {
  var onReceived: (TrophySocketResponse) -> Void { get set }

  func connect()
  func disconnect()
}

final class TrophyStorage {
  typealias OnDidBecomeActive = (@escaping () -> Void) -> AnyObject
  typealias OnWillResignActive = (@escaping () -> Void) -> AnyObject

  private let onMessageReceive: ObservableEvent
  private let connector: TrophySocketConnectorProtocol

  private var lastReceivedMessage: TrophySocketResponse?
  private var observers: [AnyObject] = []

  init(
    onMessageReceive: ObservableEvent,
    socketConnector: TrophySocketConnectorProtocol,
    onDidBecomeActive: OnDidBecomeActive,
    onWillResignActive: OnWillResignActive
  ) {

    self.onMessageReceive = onMessageReceive
    self.connector = socketConnector

    openConnectionIfNeeded()

    observers.append(onDidBecomeActive { [self] in
      openConnectionIfNeeded()
    })

    observers.append(onWillResignActive { [self] in
      closeConnection()
    })

    connector.onReceived = { [weak self] response in
      self?.lastReceivedMessage = response
      self?.onMessageReceive.send()
    }
  }
}

extension TrophyStorage {

  func getLastMessageOnce() -> TrophySocketResponse? {
    let message = lastReceivedMessage
    lastReceivedMessage = nil

    return message
  }

  func openConnectionIfNeeded() {
    connector.connect()
  }

  func closeConnection() {
    connector.disconnect()
  }
}
