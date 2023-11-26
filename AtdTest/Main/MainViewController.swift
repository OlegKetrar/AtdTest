//
//  MainViewController.swift
//

import UIKit

class MainViewController: UIViewController {
  var onButtonTap: () -> Void = {}

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .yellow

    let label = UILabel()
    label.text = "First Screen"
    label.font = .systemFont(ofSize: 18)

    let button = UIButton(type: .system)
    button.setTitle("Get achievement", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .orange
    button.layer.cornerRadius = 12
    button.layer.masksToBounds = true
    button.addTarget(self, action: #selector(actionButtonTap), for: .touchUpInside)

    view.addSubview(label)
    view.addSubview(button)

    label.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -100),

      button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
      button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),

      button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
      button.heightAnchor.constraint(equalToConstant: 50),
    ])
  }

  @objc func actionButtonTap() {
    onButtonTap()
  }
}
