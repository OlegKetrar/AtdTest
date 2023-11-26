//
//  TrophyNotificationView.swift
//

import UIKit

final class TrophyNotificationView: UIView {
  private var onTapClosure: () -> Void = {}

  // MARK: - Outlets

  let imageView = UIImageView()
  let titleLabel = UILabel()
  let descriptionLabel = UILabel()

  // MARK: - Overrides

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configureUI()
  }

  // MARK: - Public

  @discardableResult
  func onTap(_ closure: @escaping () -> Void) -> Self {
    self.onTapClosure = closure
    return self
  }

  @discardableResult
  func update(message: TrophySocketResponse) -> Self {
    titleLabel.text = message.title
    descriptionLabel.text = message.text
    return self
  }
}

// MARK: - Actions

extension TrophyNotificationView {

  @objc func actionTap() {
    onTapClosure()
  }
}

// MARK: - Private

private extension TrophyNotificationView {

  func configureUI() {
    imageView.image = UIImage(named: "trophyIcon")
    titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    descriptionLabel.font = .systemFont(ofSize: 14)
    descriptionLabel.numberOfLines = 2

    addGestureRecognizer(UITapGestureRecognizer(
      target: self,
      action: #selector(actionTap)))

    let content = makeContentView()

    addSubview(content)

    content.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      content.topAnchor.constraint(equalTo: topAnchor),
      content.leftAnchor.constraint(equalTo: leftAnchor),
      content.rightAnchor.constraint(equalTo: rightAnchor),
      content.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  func makeContentView() -> UIView {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 12
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.05
    view.layer.shadowOffset = .zero
    view.layer.shadowRadius = 16

    view.addSubview(imageView)
    view.addSubview(titleLabel)
    view.addSubview(descriptionLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
      imageView.heightAnchor.constraint(equalToConstant: 56),
      imageView.widthAnchor.constraint(equalToConstant: 56),

      titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12),
      titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),

      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
      descriptionLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12),
      descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12)
    ])

    return view
  }
}
