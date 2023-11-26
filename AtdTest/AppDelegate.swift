//
//  AppDelegate.swift
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var shared: AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
  }

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let navigationController = UINavigationController()
    let window = UIWindow()

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window

    DependencyContainer.initialise()
    let mainVC = DependencyContainer.makeMainViewController()

    navigationController.setViewControllers([mainVC], animated: false)

    return true
  }
}
