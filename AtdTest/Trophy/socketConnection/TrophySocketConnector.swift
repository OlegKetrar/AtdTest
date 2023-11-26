//
//  TrophySocketConnector.swift
//

import Foundation

final class FakeTrophyConnector: TrophySocketConnectorProtocol {

  private var isConnected: Bool = false
  var onReceived: (TrophySocketResponse) -> Void = { _ in  }

  func connect() {
    isConnected = true
  }

  func disconnect() {
    isConnected = false
  }

  func mockEventReceived() {
    guard isConnected else { return }

    let newEvent = TrophySocketResponse(
      title: "New achievement received",
      text: "Your are the \(Int.random(in: 1..<10)) customer of Autodoc")

    onReceived(newEvent)
  }
}
