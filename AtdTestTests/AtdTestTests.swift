//
//  AtdTestTests.swift
//  AtdTestTests
//
//  Created by Oleg Ketrar on 26.11.2023.
//

import XCTest
@testable import AtdTest

final class AtdTestTests: XCTestCase {

  func testExample() throws {
    var onButtonTap_callsCount = 0

    let sut = MainViewController()
    sut.onButtonTap = {
      onButtonTap_callsCount += 1
    }

    sut.actionButtonTap()
    XCTAssertEqual(onButtonTap_callsCount, 1)
  }
}
