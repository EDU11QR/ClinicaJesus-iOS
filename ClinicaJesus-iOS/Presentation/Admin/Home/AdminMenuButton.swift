//
//  AdminMenuButton.swift
//  ClinicaJesus-iOS
//
//  Created by XCODE on 25/04/26.
//

import UIKit

final class AdminMenuButton: UIControl {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    init(
        title: String,
        subtitle: String,
        icon: String,
        isDestructive: Bool = false
    ) {
        super.init(frame: .zero)
        setupUI(
            title: title,
            subtitle: subtitle,
            icon: icon,
            isDestructive: isDestructive
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no ha sido implementado")
    }
    
    private func setupUI(
        title: String,
        subtitle: String,
        icon: String,
        isDestructive: Bool
    ) {
        backgroundColor = .systemBackground
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = isDestructive ? .systemRed : .systemTeal
        iconImageView.contentMode = .scaleAspectFit
        
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = isDestructive ? .systemRed : .label
        
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 2
        
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = .systemGray3
        
        [iconImageView, titleLabel, subtitleLabel, arrowImageView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 92),
            
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 34),
            iconImageView.heightAnchor.constraint(equalToConstant: 34),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
