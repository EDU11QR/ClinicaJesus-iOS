//
//  CustomTextField.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 26/04/26.
//
import UIKit

final class CustomTextField: UIView {

    private let textField = UITextField()

    var text: String? {
        return textField.text
    }

    init(icon: String, placeholder: String, isSecure: Bool = false) {
        super.init(frame: .zero)

        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 12

        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = .gray

        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .none

        let stack = UIStackView(arrangedSubviews: [imageView, textField])
        stack.spacing = 10
        stack.alignment = .center

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
